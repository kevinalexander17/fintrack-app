import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/services/auth_service.dart';
import 'package:fintrack/models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  bool _isLoading = false;
  String? _error;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  
  // Estado de autenticación
  Stream<User?> get authStateChanges => _authService.authStateChanges();
  
  AuthProvider() {
    _authService.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }
  
  // Registro con correo y contraseña
  Future<void> registerWithEmail(String email, String password, String name) async {
    _setLoading(true);
    _clearError();
    
    try {
      _user = await _authService.signUpWithEmail(email, password, name);
      _clearError();
    } catch (e) {
      _setError(_mapAuthErrorToMessage(e.toString()));
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
  
  // Iniciar sesión con correo y contraseña
  Future<void> loginWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      _user = await _authService.signInWithEmail(email, password);
      _clearError();
    } catch (e) {
      _setError(_mapAuthErrorToMessage(e.toString()));
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
  
  // Iniciar sesión con Google
  Future<void> loginWithGoogle() async {
    _setLoading(true);
    _clearError();
    
    try {
      _user = await _authService.signInWithGoogle();
      _clearError();
    } catch (e) {
      _setError(_mapAuthErrorToMessage(e.toString()));
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
  
  // Cerrar sesión
  Future<void> logout() async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.signOut();
      _user = null;
      _clearError();
    } catch (e) {
      debugPrint('Error controlado en logout: ${e.toString()}');
      // Mostrar un mensaje más amigable al usuario
      _setError('Se cerró la sesión, pero ocurrió un problema. Por favor reinicia la aplicación si encuentras algún inconveniente.');
      // No relanzar el error para que la UI pueda continuar
    } finally {
      _setLoading(false);
    }
  }
  
  // Restablecer contraseña
  Future<void> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.resetPassword(email);
      _clearError();
    } catch (e) {
      _setError(_mapAuthErrorToMessage(e.toString()));
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
  
  // Obtener datos del usuario
  Future<Map<String, dynamic>> getUserData() async {
    if (user != null) {
      final docSnapshot = await _firestore.collection('users').doc(user!.uid).get();
      return docSnapshot.data() ?? {};
    }
    return {};
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  String _mapAuthErrorToMessage(String error) {
    if (error.contains('user-not-found') || error.contains('invalid-credential')) {
      return 'No se encontró una cuenta con este correo y contraseña.';
    } else if (error.contains('wrong-password')) {
      return 'Contraseña incorrecta.';
    } else if (error.contains('email-already-in-use')) {
      return 'Este correo ya está registrado.';
    } else if (error.contains('weak-password')) {
      return 'La contraseña es muy débil. Debe tener al menos 6 caracteres.';
    } else if (error.contains('invalid-email')) {
      return 'El formato del correo electrónico no es válido.';
    } else if (error.contains('network-request-failed')) {
      return 'Error de conexión. Verifica tu conexión a internet.';
    } else if (error.contains('too-many-requests')) {
      return 'Demasiados intentos fallidos. Intenta de nuevo más tarde.';
    } else if (error.contains('operation-not-allowed')) {
      return 'La operación no está permitida.';
    } else if (error.contains('account-exists-with-different-credential')) {
      return 'Ya existe una cuenta con el mismo correo pero usando otro método de inicio de sesión.';
    } else if (error.contains('requires-recent-login')) {
      return 'Esta operación es sensible y requiere autenticación reciente. Inicie sesión nuevamente.';
    } else if (error.contains('popup-closed-by-user')) {
      return 'El proceso de inicio de sesión fue cancelado.';
    } else if (error.contains('cancelled')) {
      return 'La operación fue cancelada por el usuario.';
    } else if (error.contains('google-signin-client-id')) {
      return 'Error de configuración de Google Sign-In. Contacta al administrador.';
    }
    
    return 'Ha ocurrido un error: $error';
  }
} 