import 'package:cloud_firestore/cloud_firestore.dart';

// Enumeración para los tipos de transacción
enum TransactionType {
  expense,
  income,
  transfer
}

// Enumeración para el estado de la transacción
enum TransactionStatus {
  pending,
  cleared,
  reconciled,
  voided
}

enum TransactionRecurrence {
  none,
  daily,
  weekly,
  biweekly,
  monthly,
  quarterly,
  yearly
}

// Clase para el modelo de transacción (renombrada)
class FinTransaction {
  final String id;
  final String userId;
  final String accountId;
  final String? toAccountId; // Para transferencias
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final String? categoryId;
  final String? subcategoryId;
  final DateTime date;
  final String? description;
  final String? notes;
  final List<String>? tags;
  final String? receiptUrl;
  final bool isRecurring;
  final Map<String, dynamic>? recurringDetails;
  final bool isConfirmed;
  final bool isPending;
  final bool isExcludedFromStats;
  final String? currencyCode;
  final double? originalAmount; // Monto en la moneda original
  final String? originalCurrency;
  final String? payee;
  final String? location;
  final Map<String, dynamic>? metadata;
  final List<dynamic>? attachments;
  final bool isExcluded;
  final DateTime createdAt;
  final DateTime updatedAt;

  FinTransaction({
    required this.id,
    required this.userId,
    required this.accountId,
    this.toAccountId,
    required this.type,
    this.status = TransactionStatus.cleared,
    required this.amount,
    this.categoryId,
    this.subcategoryId,
    required this.date,
    this.description,
    this.notes,
    this.tags,
    this.receiptUrl,
    this.isRecurring = false,
    this.recurringDetails,
    this.isConfirmed = true,
    this.isPending = false,
    this.isExcludedFromStats = false,
    this.currencyCode,
    this.originalAmount,
    this.originalCurrency,
    this.payee,
    this.location,
    this.metadata,
    this.attachments,
    this.isExcluded = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Método para clonar una transacción con cambios
  FinTransaction copyWith({
    String? id,
    String? userId,
    String? accountId,
    String? toAccountId,
    TransactionType? type,
    TransactionStatus? status,
    double? amount,
    String? categoryId,
    String? subcategoryId,
    DateTime? date,
    String? description,
    String? notes,
    List<String>? tags,
    String? receiptUrl,
    bool? isRecurring,
    Map<String, dynamic>? recurringDetails,
    bool? isConfirmed,
    bool? isPending,
    bool? isExcludedFromStats,
    String? currencyCode,
    double? originalAmount,
    String? originalCurrency,
    String? payee,
    String? location,
    Map<String, dynamic>? metadata,
    List<dynamic>? attachments,
    bool? isExcluded,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      date: date ?? this.date,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringDetails: recurringDetails ?? this.recurringDetails,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      isPending: isPending ?? this.isPending,
      isExcludedFromStats: isExcludedFromStats ?? this.isExcludedFromStats,
      currencyCode: currencyCode ?? this.currencyCode,
      originalAmount: originalAmount ?? this.originalAmount,
      originalCurrency: originalCurrency ?? this.originalCurrency,
      payee: payee ?? this.payee,
      location: location ?? this.location,
      metadata: metadata ?? this.metadata,
      attachments: attachments ?? this.attachments,
      isExcluded: isExcluded ?? this.isExcluded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Método para convertir la transacción a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'accountId': accountId,
      'toAccountId': toAccountId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'amount': amount,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'date': Timestamp.fromDate(date),
      'description': description,
      'notes': notes,
      'tags': tags,
      'receiptUrl': receiptUrl,
      'isRecurring': isRecurring,
      'recurringDetails': recurringDetails,
      'isConfirmed': isConfirmed,
      'isPending': isPending,
      'isExcludedFromStats': isExcludedFromStats,
      'currencyCode': currencyCode,
      'originalAmount': originalAmount,
      'originalCurrency': originalCurrency,
      'payee': payee,
      'location': location,
      'metadata': metadata,
      'attachments': attachments,
      'isExcluded': isExcluded,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Método para crear una transacción desde un mapa de Firestore
  factory FinTransaction.fromMap(Map<String, dynamic> map) {
    // Función auxiliar para determinar el tipo de transacción
    TransactionType getTransactionType(String type) {
      switch (type) {
        case 'expense':
          return TransactionType.expense;
        case 'income':
          return TransactionType.income;
        case 'transfer':
          return TransactionType.transfer;
        default:
          return TransactionType.expense;
      }
    }

    // Función auxiliar para determinar el estado de la transacción
    TransactionStatus getTransactionStatus(String status) {
      switch (status) {
        case 'pending':
          return TransactionStatus.pending;
        case 'cleared':
          return TransactionStatus.cleared;
        case 'reconciled':
          return TransactionStatus.reconciled;
        case 'void':
        case 'voided':
          return TransactionStatus.voided;
        default:
          return TransactionStatus.cleared;
      }
    }

    // Convertir lista de etiquetas
    List<String>? getTags(dynamic tags) {
      if (tags == null) return null;
      if (tags is List) {
        return tags.map<String>((tag) => tag.toString()).toList();
      }
      return null;
    }

    return FinTransaction(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      accountId: map['accountId'] ?? '',
      toAccountId: map['toAccountId'],
      type: getTransactionType(map['type'] ?? 'expense'),
      status: getTransactionStatus(map['status'] ?? 'cleared'),
      amount: (map['amount'] ?? 0.0).toDouble(),
      categoryId: map['categoryId'],
      subcategoryId: map['subcategoryId'],
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      description: map['description'],
      notes: map['notes'],
      tags: getTags(map['tags']),
      receiptUrl: map['receiptUrl'],
      isRecurring: map['isRecurring'] ?? false,
      recurringDetails: map['recurringDetails'],
      isConfirmed: map['isConfirmed'] ?? true,
      isPending: map['isPending'] ?? false,
      isExcludedFromStats: map['isExcludedFromStats'] ?? false,
      currencyCode: map['currencyCode'],
      originalAmount: map['originalAmount'] != null ? (map['originalAmount'] as num).toDouble() : null,
      originalCurrency: map['originalCurrency'],
      payee: map['payee'],
      location: map['location'],
      metadata: map['metadata'],
      attachments: map['attachments'],
      isExcluded: map['isExcluded'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
} 