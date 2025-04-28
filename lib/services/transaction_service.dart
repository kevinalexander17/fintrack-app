import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/models/transaction.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Colección de transacciones
  CollectionReference get _transactionsRef => _firestore.collection('transactions');
  
  // Obtener transacciones de un usuario
  Stream<List<Transaction>> getTransactions(String userId) {
    return _transactionsRef
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Transaction.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
        });
  }
  
  // Añadir una nueva transacción
  Future<String> addTransaction(Transaction transaction) async {
    final docRef = await _transactionsRef.add(transaction.toMap());
    return docRef.id;
  }
  
  // Actualizar una transacción existente
  Future<void> updateTransaction(Transaction transaction) async {
    await _transactionsRef.doc(transaction.id).update(transaction.toMap());
  }
  
  // Eliminar una transacción
  Future<void> deleteTransaction(String transactionId) async {
    await _transactionsRef.doc(transactionId).delete();
  }
  
  // Obtener transacciones por período
  Stream<List<Transaction>> getTransactionsByPeriod(
      String userId, DateTime startDate, DateTime endDate) {
    return _transactionsRef
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Transaction.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
        });
  }
  
  // Obtener transacciones por categoría
  Stream<List<Transaction>> getTransactionsByCategory(
      String userId, String categoryId) {
    return _transactionsRef
        .where('userId', isEqualTo: userId)
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Transaction.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
        });
  }
} 