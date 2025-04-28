import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/account.dart';

class AccountService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Referencia a la colección de cuentas
  CollectionReference get _accountsCollection => _firestore.collection('accounts');

  // Obtener el ID del usuario actual
  String? get _currentUserId => _auth.currentUser?.uid;

  // Obtener todas las cuentas del usuario actual
  Stream<List<Account>> getAccounts() {
    if (_currentUserId == null) return Stream.value([]);

    return _accountsCollection
        .where('userId', isEqualTo: _currentUserId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Account.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }

  // Obtener una cuenta específica por ID
  Future<Account?> getAccount(String accountId) async {
    if (_currentUserId == null) return null;

    final doc = await _accountsCollection.doc(accountId).get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    if (data['userId'] != _currentUserId) return null;

    return Account.fromMap({...data, 'id': doc.id});
  }

  // Crear una nueva cuenta
  Future<String> createAccount(Account account) async {
    if (_currentUserId == null) {
      throw Exception('El usuario no está autenticado');
    }

    // Asegurarse de que la cuenta pertenece al usuario actual
    final newAccount = account.copyWith(
      userId: _currentUserId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final docRef = await _accountsCollection.add(newAccount.toMap());
    return docRef.id;
  }

  // Actualizar una cuenta existente
  Future<void> updateAccount(Account account) async {
    if (_currentUserId == null) {
      throw Exception('El usuario no está autenticado');
    }

    if (account.id == null) {
      throw Exception('La cuenta no tiene un ID válido');
    }

    // Verificar que la cuenta pertenece al usuario actual
    final doc = await _accountsCollection.doc(account.id).get();
    if (!doc.exists) {
      throw Exception('La cuenta no existe');
    }

    final data = doc.data() as Map<String, dynamic>;
    if (data['userId'] != _currentUserId) {
      throw Exception('No tienes permiso para actualizar esta cuenta');
    }

    // Actualizar la cuenta
    final updatedAccount = account.copyWith(updatedAt: DateTime.now());
    await _accountsCollection.doc(account.id).update(updatedAccount.toMap());
  }

  // Eliminar una cuenta
  Future<void> deleteAccount(String accountId) async {
    if (_currentUserId == null) {
      throw Exception('El usuario no está autenticado');
    }

    // Verificar que la cuenta pertenece al usuario actual
    final doc = await _accountsCollection.doc(accountId).get();
    if (!doc.exists) {
      throw Exception('La cuenta no existe');
    }

    final data = doc.data() as Map<String, dynamic>;
    if (data['userId'] != _currentUserId) {
      throw Exception('No tienes permiso para eliminar esta cuenta');
    }

    // Eliminar la cuenta
    await _accountsCollection.doc(accountId).delete();
  }

  // Obtener el balance total
  Future<double> getTotalBalance(String userId, {String currency = 'S/.'}) async {
    final snapshot = await _firestore
        .collection('accounts')
        .where('userId', isEqualTo: userId)
        .where('currency', isEqualTo: currency)
        .get();
    
    double total = 0.0;
    for (var doc in snapshot.docs) {
      final account = Account.fromMap(doc.data(), doc.id);
      total += account.balance;
    }
    
    return total;
  }

  // Obtener total de activos
  Future<double> getTotalAssets(String userId, {String currency = 'S/.'}) async {
    final snapshot = await _firestore
        .collection('accounts')
        .where('userId', isEqualTo: userId)
        .where('currency', isEqualTo: currency)
        .where('type', isEqualTo: 'asset')
        .get();
    
    double total = 0.0;
    for (var doc in snapshot.docs) {
      final account = Account.fromMap(doc.data(), doc.id);
      total += account.balance;
    }
    
    return total;
  }

  // Obtener total de pasivos
  Future<double> getTotalLiabilities(String userId, {String currency = 'S/.'}) async {
    final snapshot = await _firestore
        .collection('accounts')
        .where('userId', isEqualTo: userId)
        .where('currency', isEqualTo: currency)
        .where('type', isEqualTo: 'liability')
        .get();
    
    double total = 0.0;
    for (var doc in snapshot.docs) {
      final account = Account.fromMap(doc.data(), doc.id);
      total += account.balance;
    }
    
    return total;
  }
} 