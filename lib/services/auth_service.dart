import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Estado del usuario actual
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;

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
        });
        
        // Actualizar el displayName del usuario
        await userCredential.user!.updateDisplayName(name);
      }
      
      return userCredential;
    } catch (e) {
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
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Inicio de sesión con Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // Obtener detalles de autenticación de la solicitud
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      
      if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
        throw Exception('No se pudo completar la autenticación con Google');
      }
      
      // Crear una credencial para Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Iniciar sesión en Firebase con la credencial
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Verificar si es un usuario nuevo o existente
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // Crear documento de usuario en Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName,
          'photoUrl': userCredential.user!.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'authProvider': 'google',
        });
      } else {
        // Actualizar última conexión
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Cambiar contraseña
  Future<void> changePassword(String newPassword) async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updatePassword(newPassword);
    } else {
      throw Exception("No hay usuario autenticado");
    }
  }

  // Restablecer contraseña
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Actualizar perfil de usuario
  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(displayName);
      await _auth.currentUser!.updatePhotoURL(photoURL);
      
      // Actualizar también en Firestore
      Map<String, dynamic> updateData = {};
      if (displayName != null) updateData['name'] = displayName;
      if (photoURL != null) updateData['photoUrl'] = photoURL;
      
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update(updateData);
    } else {
      throw Exception("No hay usuario autenticado");
    }
  }
} 