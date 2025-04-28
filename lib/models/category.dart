import 'package:cloud_firestore/cloud_firestore.dart';

// Tipo de transacción que puede usar esta categoría
enum CategoryType {
  expense,
  income,
  transfer
}

class Category {
  final String id;
  final String userId;
  final String name;
  final String? parentId;
  final String? iconId;
  final String? color;
  final int order;
  final bool isIncome;
  final bool isDefault;
  final bool isHidden;
  final List<String>? childrenIds;
  final Map<String, dynamic>? budget;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    this.parentId,
    this.iconId,
    this.color,
    this.order = 0,
    this.isIncome = false,
    this.isDefault = false,
    this.isHidden = false,
    this.childrenIds,
    this.budget,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  // Método para clonar una categoría con cambios
  Category copyWith({
    String? id,
    String? userId,
    String? name,
    String? parentId,
    String? iconId,
    String? color,
    int? order,
    bool? isIncome,
    bool? isDefault,
    bool? isHidden,
    List<String>? childrenIds,
    Map<String, dynamic>? budget,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      iconId: iconId ?? this.iconId,
      color: color ?? this.color,
      order: order ?? this.order,
      isIncome: isIncome ?? this.isIncome,
      isDefault: isDefault ?? this.isDefault,
      isHidden: isHidden ?? this.isHidden,
      childrenIds: childrenIds ?? this.childrenIds,
      budget: budget ?? this.budget,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Método para convertir la categoría a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'parentId': parentId,
      'iconId': iconId,
      'color': color,
      'order': order,
      'isIncome': isIncome,
      'isDefault': isDefault,
      'isHidden': isHidden,
      'childrenIds': childrenIds,
      'budget': budget,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Método para crear una categoría desde un mapa de Firestore
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      parentId: map['parentId'],
      iconId: map['iconId'],
      color: map['color'],
      order: map['order'] ?? 0,
      isIncome: map['isIncome'] ?? false,
      isDefault: map['isDefault'] ?? false,
      isHidden: map['isHidden'] ?? false,
      childrenIds: map['childrenIds'] != null 
          ? List<String>.from(map['childrenIds']) 
          : null,
      budget: map['budget'],
      metadata: map['metadata'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
} 