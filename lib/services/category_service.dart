import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/models/category.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Colección de categorías
  CollectionReference get _categoriesRef => _firestore.collection('categories');
  
  // Obtener categorías de un usuario
  Stream<List<Category>> getCategories(String userId) {
    return _categoriesRef
        .where('userId', isEqualTo: userId)
        .orderBy('order', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
        });
  }
  
  // Obtener una categoría por su ID
  Future<Category?> getCategoryById(String categoryId) async {
    final doc = await _categoriesRef.doc(categoryId).get();
    if (doc.exists) {
      return Category.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
  
  // Añadir una nueva categoría
  Future<String> addCategory(Category category) async {
    final docRef = await _categoriesRef.add(category.toMap());
    return docRef.id;
  }
  
  // Actualizar una categoría existente
  Future<void> updateCategory(Category category) async {
    await _categoriesRef.doc(category.id).update(category.toMap());
  }
  
  // Eliminar una categoría
  Future<void> deleteCategory(String categoryId) async {
    await _categoriesRef.doc(categoryId).delete();
  }
  
  // Obtener subcategorías de una categoría principal
  Stream<List<Category>> getSubcategories(String parentId) {
    return _categoriesRef
        .where('parentId', isEqualTo: parentId)
        .orderBy('order', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
        });
  }
  
  // Obtener categorías por tipo (ingresos o gastos)
  Stream<List<Category>> getCategoriesByType(String userId, bool isIncome) {
    return _categoriesRef
        .where('userId', isEqualTo: userId)
        .where('isIncome', isEqualTo: isIncome)
        .where('parentId', isNull: true)
        .orderBy('order', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
        });
  }
} 