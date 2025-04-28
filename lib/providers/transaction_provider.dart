import 'package:flutter/material.dart';
import 'package:fintrack/models/transaction.dart';
import 'package:fintrack/models/category.dart';
import 'package:fintrack/services/transaction_service.dart';
import 'package:fintrack/providers/category_provider.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  final CategoryProvider _categoryProvider;
  List<FinTransaction> _transactions = [];
  List<FinTransaction> _filteredTransactions = [];
  bool _isLoading = false;
  String _errorMessage = '';
  
  TransactionProvider(this._categoryProvider);
  
  // Getters
  List<FinTransaction> get transactions => _transactions;
  List<FinTransaction> get filteredTransactions => _filteredTransactions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  
  // Cargar transacciones de un usuario
  Future<void> loadTransactions(String userId) async {
    _setLoading(true);
    
    try {
      _transactionService.getTransactions(userId).listen((transactions) {
        _transactions = transactions;
        _filteredTransactions = transactions;
        _setLoading(false);
        notifyListeners();
      }, onError: (error) {
        _setError('Error al cargar transacciones: $error');
      });
    } catch (e) {
      _setError('Error al cargar transacciones: $e');
    }
  }
  
  // Filtrar transacciones por período
  void filterByPeriod(DateTime startDate, DateTime endDate) {
    _filteredTransactions = _transactions.where((transaction) {
      return transaction.date.isAfter(startDate) && 
             transaction.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
    notifyListeners();
  }
  
  // Filtrar transacciones por categoría
  void filterByCategory(String categoryId) {
    if (categoryId == 'all') {
      _filteredTransactions = _transactions;
    } else {
      _filteredTransactions = _transactions.where((transaction) {
        return transaction.categoryId == categoryId;
      }).toList();
    }
    notifyListeners();
  }
  
  // Filtrar transacciones por tipo
  void filterByType(TransactionType type) {
    _filteredTransactions = _transactions.where((transaction) {
      return transaction.type == type;
    }).toList();
    notifyListeners();
  }
  
  // Resetear filtros
  void resetFilters() {
    _filteredTransactions = _transactions;
    notifyListeners();
  }
  
  // Añadir una nueva transacción
  Future<void> addTransaction(FinTransaction transaction) async {
    _setLoading(true);
    
    try {
      await _transactionService.addTransaction(transaction);
      _setLoading(false);
    } catch (e) {
      _setError('Error al añadir transacción: $e');
    }
  }
  
  // Actualizar una transacción existente
  Future<void> updateTransaction(FinTransaction transaction) async {
    _setLoading(true);
    
    try {
      await _transactionService.updateTransaction(transaction);
      _setLoading(false);
    } catch (e) {
      _setError('Error al actualizar transacción: $e');
    }
  }
  
  // Eliminar una transacción
  Future<void> deleteTransaction(String transactionId) async {
    _setLoading(true);
    
    try {
      await _transactionService.deleteTransaction(transactionId);
      _setLoading(false);
    } catch (e) {
      _setError('Error al eliminar transacción: $e');
    }
  }
  
  // Obtener transacciones por período
  Future<void> getTransactionsByPeriod(
      String userId, DateTime startDate, DateTime endDate) async {
    _setLoading(true);
    
    try {
      _transactionService.getTransactionsByPeriod(
          userId, startDate, endDate).listen((transactions) {
        _transactions = transactions;
        _filteredTransactions = transactions;
        _setLoading(false);
        notifyListeners();
      }, onError: (error) {
        _setError('Error al cargar transacciones: $error');
      });
    } catch (e) {
      _setError('Error al cargar transacciones: $e');
    }
  }
  
  // Obtener categoría de una transacción
  Category? getCategoryForTransaction(FinTransaction transaction) {
    if (transaction.categoryId == null) return null;
    return _categoryProvider.getCategoryById(transaction.categoryId!);
  }
  
  // Obtener nombre de categoría para una transacción
  String getCategoryNameForTransaction(FinTransaction transaction) {
    if (transaction.categoryId == null) {
      return transaction.type == TransactionType.income ? 'Ingreso' : 'Sin categoría';
    }
    
    final category = _categoryProvider.getCategoryById(transaction.categoryId!);
    return category?.name ?? 'Sin categoría';
  }
  
  // Calcular total de ingresos en un período
  double calculateTotalIncome(DateTime startDate, DateTime endDate) {
    return _transactions
        .where((transaction) => 
            transaction.type == TransactionType.income &&
            transaction.date.isAfter(startDate) && 
            transaction.date.isBefore(endDate.add(const Duration(days: 1))))
        .fold(0, (double sum, transaction) => sum + transaction.amount);
  }
  
  // Calcular total de gastos en un período
  double calculateTotalExpense(DateTime startDate, DateTime endDate) {
    return _transactions
        .where((transaction) => 
            transaction.type == TransactionType.expense &&
            transaction.date.isAfter(startDate) && 
            transaction.date.isBefore(endDate.add(const Duration(days: 1))))
        .fold(0, (double sum, transaction) => sum + transaction.amount);
  }
  
  // Calcular gastos por categoría
  Map<String, double> calculateExpensesByCategory(DateTime startDate, DateTime endDate) {
    Map<String, double> expensesByCategory = {};
    
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.expense &&
          transaction.date.isAfter(startDate) && 
          transaction.date.isBefore(endDate.add(const Duration(days: 1))) &&
          transaction.categoryId != null) {
        
        final categoryName = getCategoryNameForTransaction(transaction);
        
        expensesByCategory.update(
          categoryName, 
          (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount
        );
      }
    }
    
    return expensesByCategory;
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