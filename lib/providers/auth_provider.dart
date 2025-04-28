import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.currentUser != null;
  
  // Estado de autenticación
  Stream<User?> get authStateChanges => _authService.authStateChanges;
  
  // Registro con correo y contraseña
  Future<UserCredential> registerWithEmail(String email, String password, String name) async {
    try {
      final UserCredential userCredential = await _authService.signUpWithEmail(
        email,
        password,
        name,
      );
      
      notifyListeners();
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
  
  // Iniciar sesión con correo y contraseña
  Future<UserCredential> loginWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _authService.signInWithEmail(
        email,
        password,
      );
      
      notifyListeners();
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
  
  // Iniciar sesión con Google
  Future<UserCredential> loginWithGoogle() async {
    try {
      final UserCredential userCredential = await _authService.signInWithGoogle();
      
      notifyListeners();
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
  
  // Cerrar sesión
  Future<void> logout() async {
    await _authService.signOut();
    notifyListeners();
  }
  
  // Restablecer contraseña
  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }
  
  // Obtener datos del usuario
  Future<Map<String, dynamic>> getUserData() async {
    if (currentUser != null) {
      final docSnapshot = await _firestore.collection('users').doc(currentUser!.uid).get();
      return docSnapshot.data() ?? {};
    }
    return {};
  }
} 