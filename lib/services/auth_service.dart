import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final GoogleSignIn _googleSignIn;

  AuthService() {
    // Inicializar GoogleSignIn con la configuración adecuada
    _googleSignIn = GoogleSignIn(
      // Para ambiente web, especificar el clientId
      clientId: kIsWeb ? '146618088443-p79pv5jbmt8g1g29q4mndt5qan2pg8ii.apps.googleusercontent.com' : null,
      scopes: ['email', 'profile'],
    );
  }

  // Estado del usuario actual
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;

  // Verificar si un usuario existe en Firestore
  Future<bool> userExistsInFirestore(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      return docSnapshot.exists;
    } catch (e) {
      debugPrint('Error verificando usuario en Firestore: $e');
      return false;
    }
  }

  // Registro con email y contraseña
  Future<UserCredential> signUpWithEmail(
      String email, String password, String name) async {
    try {
      // Crear usuario en Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Crear documento de usuario en Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'name': name,
          'photoUrl': userCredential.user!.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'authProvider': 'email',
        });
        
        // Actualizar el displayName del usuario
        await userCredential.user!.updateDisplayName(name);
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error en signUpWithEmail: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error inesperado en signUpWithEmail: $e');
      rethrow;
    }
  }

  // Inicio de sesión con email y contraseña
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Actualizar última conexión
      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;
        
        // Verificar si el usuario existe en Firestore
        bool exists = await userExistsInFirestore(uid);
        
        if (exists) {
          await _firestore.collection('users').doc(uid).update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
        } else {
          // Si el usuario no existe en Firestore, crearlo
          await _firestore.collection('users').doc(uid).set({
            'uid': uid,
            'email': email,
            'name': userCredential.user!.displayName ?? email.split('@')[0],
            'photoUrl': userCredential.user!.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
            'authProvider': 'email',
          });
        }
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error en signInWithEmail: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error inesperado en signInWithEmail: $e');
      rethrow;
    }
  }

  // Inicio de sesión con Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Autenticación para Web
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        
        return await _auth.signInWithPopup(googleProvider);
      } else {
        // Autenticación para mobile
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        
        if (googleUser == null) {
          throw Exception('Inicio de sesión con Google cancelado por el usuario');
        }
        
        // Obtener detalles de autenticación de la solicitud
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        
        // Crear una credencial para Firebase
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        
        // Iniciar sesión en Firebase con la credencial
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        
        // Verificar si es un usuario nuevo o existente
        if (userCredential.user != null) {
          final uid = userCredential.user!.uid;
          final bool exists = await userExistsInFirestore(uid);
          
          if (!exists) {
            // Crear documento de usuario en Firestore
            await _firestore.collection('users').doc(uid).set({
              'uid': uid,
              'email': userCredential.user!.email,
              'name': userCredential.user!.displayName,
              'photoUrl': userCredential.user!.photoURL,
              'createdAt': FieldValue.serverTimestamp(),
              'lastLogin': FieldValue.serverTimestamp(),
              'authProvider': 'google',
            });
          } else {
            // Actualizar última conexión
            await _firestore.collection('users').doc(uid).update({
              'lastLogin': FieldValue.serverTimestamp(),
              'photoUrl': userCredential.user!.photoURL, // Actualizar foto por si cambió
            });
          }
        }
        
        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Error de Firebase en signInWithGoogle: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error inesperado en signInWithGoogle: $e');
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      debugPrint('Iniciando cierre de sesión...');
      
      // Cerrar sesión de Google (si está disponible)
      if (!kIsWeb) {
        try {
          final isSignedIn = await _googleSignIn.isSignedIn();
          if (isSignedIn) {
            await _googleSignIn.disconnect();
            await _googleSignIn.signOut();
          }
        } catch (e) {
          debugPrint('Error al cerrar sesión en Google: $e');
          // Continuar con el cierre de sesión de Firebase aunque falle Google
        }
      } else {
        // En web, simplemente cerrar sesión sin intentar desconectar Google
        debugPrint('Cerrando sesión en ambiente web');
      }
      
      // Cerrar sesión en Firebase Auth
      await _auth.signOut();
      debugPrint('Sesión cerrada correctamente');
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
      // No relanzar el error para permitir un cierre de sesión limpio
      // Mostrar un mensaje más amigable sería manejado en el Provider
    }
  }

  // Cambiar contraseña
  Future<void> changePassword(String newPassword) async {
    if (_auth.currentUser != null) {
      try {
        await _auth.currentUser!.updatePassword(newPassword);
      } catch (e) {
        debugPrint('Error al cambiar contraseña: $e');
        rethrow;
      }
    } else {
      throw Exception("No hay usuario autenticado");
    }
  }

  // Restablecer contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error al restablecer contraseña: $e');
      rethrow;
    }
  }

  // Actualizar perfil de usuario
  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    if (_auth.currentUser != null) {
      try {
        if (displayName != null) {
          await _auth.currentUser!.updateDisplayName(displayName);
        }
        
        if (photoURL != null) {
          await _auth.currentUser!.updatePhotoURL(photoURL);
        }
        
        // Actualizar también en Firestore
        Map<String, dynamic> updateData = {};
        if (displayName != null) updateData['name'] = displayName;
        if (photoURL != null) updateData['photoUrl'] = photoURL;
        
        if (updateData.isNotEmpty) {
          await _firestore.collection('users').doc(_auth.currentUser!.uid).update(updateData);
        }
      } catch (e) {
        debugPrint('Error al actualizar perfil: $e');
        rethrow;
      }
    } else {
      throw Exception("No hay usuario autenticado");
    }
  }
} 