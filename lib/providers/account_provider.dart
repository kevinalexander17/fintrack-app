import 'package:flutter/material.dart';
import 'package:fintrack/models/account.dart';
import 'package:fintrack/services/account_service.dart';

class AccountProvider extends ChangeNotifier {
  final AccountService _accountService = AccountService();
  List<Account> _accounts = [];
  bool _isLoading = false;
  String _errorMessage = '';
  
  // Getters
  List<Account> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  
  // Cargar cuentas de un usuario
  void loadAccounts() {
    _setLoading(true);
    
    try {
      _accountService.getAccounts().listen((accounts) {
        _accounts = accounts;
        _setLoading(false);
        notifyListeners();
      }, onError: (error) {
        _setError('Error al cargar cuentas: $error');
      });
    } catch (e) {
      _setError('Error al cargar cuentas: $e');
    }
  }
  
  // Añadir una nueva cuenta
  Future<String?> addAccount(Account account) async {
    _setLoading(true);
    
    try {
      final docId = await _accountService.createAccount(account);
      _setLoading(false);
      return docId;
    } catch (e) {
      _setError('Error al añadir cuenta: $e');
      return null;
    }
  }
  
  // Actualizar una cuenta existente
  Future<void> updateAccount(Account account) async {
    _setLoading(true);
    
    try {
      await _accountService.updateAccount(account);
      _setLoading(false);
    } catch (e) {
      _setError('Error al actualizar cuenta: $e');
    }
  }
  
  // Eliminar una cuenta
  Future<void> deleteAccount(String accountId) async {
    _setLoading(true);
    
    try {
      await _accountService.deleteAccount(accountId);
      _setLoading(false);
    } catch (e) {
      _setError('Error al eliminar cuenta: $e');
    }
  }
  
  // Obtener el balance total
  Future<double> getTotalBalance(String userId, {String currency = 'S/.'}) async {
    try {
      return await _accountService.getTotalBalance(userId, currency: currency);
    } catch (e) {
      _setError('Error al obtener balance total: $e');
      return 0.0;
    }
  }
  
  // Obtener total de activos
  Future<double> getTotalAssets(String userId, {String currency = 'S/.'}) async {
    try {
      return await _accountService.getTotalAssets(userId, currency: currency);
    } catch (e) {
      _setError('Error al obtener activos totales: $e');
      return 0.0;
    }
  }
  
  // Obtener total de pasivos
  Future<double> getTotalLiabilities(String userId, {String currency = 'S/.'}) async {
    try {
      return await _accountService.getTotalLiabilities(userId, currency: currency);
    } catch (e) {
      _setError('Error al obtener pasivos totales: $e');
      return 0.0;
    }
  }
  
  // Métodos auxiliares
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _errorMessage = '';
    }
    notifyListeners();
  }
  
  void _setError(String errorMessage) {
    _isLoading = false;
    _errorMessage = errorMessage;
    notifyListeners();
  }
} 