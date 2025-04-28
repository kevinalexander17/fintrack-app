import 'package:flutter/material.dart';
import 'package:fintrack/constants/app_theme.dart';

class ExpenseCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<String> subcategories;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.subcategories,
  });
}

// Categorías de gastos comunes en Perú
final List<ExpenseCategory> expenseCategories = [
  // Alimentación
  ExpenseCategory(
    id: 'food',
    name: 'Alimentación',
    icon: Icons.restaurant,
    color: AppTheme.foodColor,
    subcategories: [
      'Mercado',
      'Restaurantes',
      'Delivery',
      'Comida rápida',
      'Menú del día',
    ],
  ),
  
  // Transporte
  ExpenseCategory(
    id: 'transport',
    name: 'Transporte',
    icon: Icons.directions_bus,
    color: AppTheme.transportColor,
    subcategories: [
      'Taxi',
      'Uber/Beat',
      'Mototaxi',
      'Metropolitano',
      'Micro/Combi',
      'Combustible',
      'Mantenimiento vehículo',
    ],
  ),
  
  // Salud
  ExpenseCategory(
    id: 'health',
    name: 'Salud',
    icon: Icons.health_and_safety,
    color: AppTheme.healthColor,
    subcategories: [
      'Consultas médicas',
      'Medicamentos',
      'Seguros de salud',
      'Hospitalización',
      'Exámenes médicos',
    ],
  ),
  
  // Educación
  ExpenseCategory(
    id: 'education',
    name: 'Educación',
    icon: Icons.school,
    color: AppTheme.educationColor,
    subcategories: [
      'Universidad',
      'Cursos',
      'Materiales',
      'Libros',
      'Academias',
    ],
  ),
  
  // Servicios Públicos
  ExpenseCategory(
    id: 'utilities',
    name: 'Servicios',
    icon: Icons.wb_incandescent,
    color: AppTheme.utilitiesColor,
    subcategories: [
      'Luz',
      'Agua',
      'Internet',
      'Cable',
      'Teléfono',
      'Gas',
    ],
  ),
  
  // Vivienda
  ExpenseCategory(
    id: 'housing',
    name: 'Vivienda',
    icon: Icons.home,
    color: Colors.brown,
    subcategories: [
      'Alquiler',
      'Hipoteca',
      'Mantenimiento',
      'Arbitrios',
      'Condominio',
    ],
  ),
  
  // Entretenimiento
  ExpenseCategory(
    id: 'entertainment',
    name: 'Entretenimiento',
    icon: Icons.movie,
    color: Colors.deepPurple,
    subcategories: [
      'Cine',
      'Conciertos',
      'Suscripciones',
      'Juegos',
      'Salidas',
    ],
  ),
  
  // Compras
  ExpenseCategory(
    id: 'shopping',
    name: 'Compras',
    icon: Icons.shopping_bag,
    color: Colors.pink,
    subcategories: [
      'Ropa',
      'Tecnología',
      'Muebles',
      'Artículos del hogar',
      'Regalos',
    ],
  ),
  
  // Otros
  ExpenseCategory(
    id: 'others',
    name: 'Otros',
    icon: Icons.more_horiz,
    color: Colors.grey,
    subcategories: [
      'Imprevistos',
      'Impuestos',
      'Donaciones',
      'Mascotas',
      'Varios',
    ],
  ),
]; 