import 'package:flutter/material.dart';
import 'package:fintrack/models/category.dart';
import 'package:fintrack/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  Map<String, Category> _categoriesMap = {};
  bool _isLoading = false;
  String _errorMessage = '';
  
  // Getters
  List<Category> get categories => _categories;
  Map<String, Category> get categoriesMap => _categoriesMap;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  
  // Cargar categorías de un usuario
  Future<void> loadCategories(String userId) async {
    _setLoading(true);
    
    try {
      _categoryService.getCategories(userId).listen((categories) {
        _categories = categories;
        _categoriesMap = {for (var cat in categories) cat.id: cat};
        _setLoading(false);
        notifyListeners();
      }, onError: (error) {
        _setError('Error al cargar categorías: $error');
      });
    } catch (e) {
      _setError('Error al cargar categorías: $e');
    }
  }
  
  // Obtener categoría por su ID
  Category? getCategoryById(String categoryId) {
    return _categoriesMap[categoryId];
  }
  
  // Obtener categorías principales (no subcategorías)
  List<Category> getMainCategories() {
    return _categories.where((cat) => cat.parentId == null).toList();
  }
  
  // Obtener subcategorías de una categoría principal
  List<Category> getSubcategories(String parentId) {
    return _categories.where((cat) => cat.parentId == parentId).toList();
  }
  
  // Obtener categorías de gastos
  List<Category> getExpenseCategories() {
    return _categories.where((cat) => !cat.isIncome && cat.parentId == null).toList();
  }
  
  // Obtener categorías de ingresos
  List<Category> getIncomeCategories() {
    return _categories.where((cat) => cat.isIncome && cat.parentId == null).toList();
  }
  
  // Añadir una nueva categoría
  Future<void> addCategory(Category category) async {
    _setLoading(true);
    
    try {
      await _categoryService.addCategory(category);
      _setLoading(false);
    } catch (e) {
      _setError('Error al añadir categoría: $e');
    }
  }
  
  // Actualizar una categoría existente
  Future<void> updateCategory(Category category) async {
    _setLoading(true);
    
    try {
      await _categoryService.updateCategory(category);
      _setLoading(false);
    } catch (e) {
      _setError('Error al actualizar categoría: $e');
    }
  }
  
  // Eliminar una categoría
  Future<void> deleteCategory(String categoryId) async {
    _setLoading(true);
    
    try {
      await _categoryService.deleteCategory(categoryId);
      _setLoading(false);
    } catch (e) {
      _setError('Error al eliminar categoría: $e');
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