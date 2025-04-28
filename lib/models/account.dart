import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Enumeración para los tipos de cuenta
enum AccountType {
  checking,
  savings,
  cash,
  creditCard,
  loan,
  investment,
  asset,
  debt,
  other
}

// Clase para el modelo de cuenta
class Account {
  final String id;
  final String userId;
  final String name;
  final AccountType type;
  final double balance;
  final double? creditLimit;
  final String? institutionName;
  final String? accountNumber;
  final String? currencyCode;
  final bool isExcluded;
  final bool isClosed;
  final int order;
  final String? iconId;
  final String? color;
  final bool isHidden;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.balance,
    this.creditLimit,
    this.institutionName,
    this.accountNumber,
    this.currencyCode = 'USD',
    this.isExcluded = false,
    this.isClosed = false,
    this.order = 0,
    this.iconId,
    this.color,
    this.isHidden = false,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  // Método para clonar una cuenta con cambios
  Account copyWith({
    String? id,
    String? userId,
    String? name,
    AccountType? type,
    double? balance,
    double? creditLimit,
    String? institutionName,
    String? accountNumber,
    String? currencyCode,
    bool? isExcluded,
    bool? isClosed,
    int? order,
    String? iconId,
    String? color,
    bool? isHidden,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      creditLimit: creditLimit ?? this.creditLimit,
      institutionName: institutionName ?? this.institutionName,
      accountNumber: accountNumber ?? this.accountNumber,
      currencyCode: currencyCode ?? this.currencyCode,
      isExcluded: isExcluded ?? this.isExcluded,
      isClosed: isClosed ?? this.isClosed,
      order: order ?? this.order,
      iconId: iconId ?? this.iconId,
      color: color ?? this.color,
      isHidden: isHidden ?? this.isHidden,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Método para convertir la cuenta a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'type': type.toString().split('.').last,
      'balance': balance,
      'creditLimit': creditLimit,
      'institutionName': institutionName,
      'accountNumber': accountNumber,
      'currencyCode': currencyCode,
      'isExcluded': isExcluded,
      'isClosed': isClosed,
      'order': order,
      'iconId': iconId,
      'color': color,
      'isHidden': isHidden,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Método para crear una cuenta desde un mapa de Firestore
  factory Account.fromMap(Map<String, dynamic> map) {
    // Función auxiliar para determinar el tipo de cuenta
    AccountType _getAccountType(String type) {
      switch (type) {
        case 'checking':
          return AccountType.checking;
        case 'savings':
          return AccountType.savings;
        case 'cash':
          return AccountType.cash;
        case 'creditCard':
          return AccountType.creditCard;
        case 'loan':
          return AccountType.loan;
        case 'investment':
          return AccountType.investment;
        case 'asset':
          return AccountType.asset;
        case 'debt':
          return AccountType.debt;
        case 'other':
          return AccountType.other;
        default:
          return AccountType.other;
      }
    }

    return Account(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      type: _getAccountType(map['type'] ?? 'other'),
      balance: (map['balance'] ?? 0.0).toDouble(),
      creditLimit: map['creditLimit']?.toDouble(),
      institutionName: map['institutionName'],
      accountNumber: map['accountNumber'],
      currencyCode: map['currencyCode'] ?? 'USD',
      isExcluded: map['isExcluded'] ?? false,
      isClosed: map['isClosed'] ?? false,
      order: map['order'] ?? 0,
      iconId: map['iconId'],
      color: map['color'],
      isHidden: map['isHidden'] ?? false,
      metadata: map['metadata'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
} 