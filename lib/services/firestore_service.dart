import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Referencia a colecciones principales
  CollectionReference get usersRef => _firestore.collection('users');
  CollectionReference get accountsRef => _firestore.collection('accounts');
  CollectionReference get categoriesRef => _firestore.collection('categories');
  CollectionReference get transactionsRef => _firestore.collection('transactions');

  // CRUD genérico para documentos
  
  // Crear documento con ID generado
  Future<DocumentReference> addDocument(
    CollectionReference collection, 
    Map<String, dynamic> data
  ) async {
    return await collection.add(data);
  }
  
  // Crear documento con ID específico
  Future<void> setDocument(
    CollectionReference collection, 
    String documentId, 
    Map<String, dynamic> data, 
    {bool merge = true}
  ) async {
    await collection.doc(documentId).set(data, SetOptions(merge: merge));
  }
  
  // Obtener documento por ID
  Future<DocumentSnapshot> getDocument(
    CollectionReference collection, 
    String documentId
  ) async {
    return await collection.doc(documentId).get();
  }
  
  // Actualizar documento
  Future<void> updateDocument(
    CollectionReference collection, 
    String documentId, 
    Map<String, dynamic> data
  ) async {
    await collection.doc(documentId).update(data);
  }
  
  // Eliminar documento
  Future<void> deleteDocument(
    CollectionReference collection, 
    String documentId
  ) async {
    await collection.doc(documentId).delete();
  }
  
  // Consultas comunes
  
  // Obtener documentos con filtros
  Stream<QuerySnapshot> getDocuments(
    CollectionReference collection, 
    {List<List<dynamic>>? whereConditions, 
    String? orderBy, 
    bool descending = false, 
    int? limit}
  ) {
    Query query = collection;
    
    // Aplicar condiciones where si existen
    if (whereConditions != null) {
      for (var condition in whereConditions) {
        if (condition.length == 3) {
          query = query.where(
            condition[0], 
            isEqualTo: condition[1] == '==' ? condition[2] : null,
            isNotEqualTo: condition[1] == '!=' ? condition[2] : null,
            isLessThan: condition[1] == '<' ? condition[2] : null,
            isLessThanOrEqualTo: condition[1] == '<=' ? condition[2] : null,
            isGreaterThan: condition[1] == '>' ? condition[2] : null,
            isGreaterThanOrEqualTo: condition[1] == '>=' ? condition[2] : null,
            arrayContains: condition[1] == 'array-contains' ? condition[2] : null,
          );
        }
      }
    }
    
    // Aplicar ordenamiento si existe
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    
    // Aplicar límite si existe
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots();
  }
  
  // Transacciones
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) transactionHandler
  ) async {
    return await _firestore.runTransaction(transactionHandler);
  }
  
  // Operaciones en lote
  WriteBatch batch() {
    return _firestore.batch();
  }
} 