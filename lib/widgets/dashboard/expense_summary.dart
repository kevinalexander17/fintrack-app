import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fintrack/constants/app_theme.dart';
import 'package:fintrack/constants/expense_categories.dart';

class ExpenseSummary extends StatelessWidget {
  const ExpenseSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gastos por Categoría',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navegar a la pantalla de análisis detallado
                },
                child: const Text('Ver más'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: _getSections(),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: _buildLegend(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    // Ejemplo de datos, en una aplicación real estos vendrían de un proveedor o servicio
    final List<MapEntry<String, double>> expenseData = [
      MapEntry(expenseCategories[0].name, 850.0), // Alimentación
      MapEntry(expenseCategories[1].name, 450.0), // Transporte
      MapEntry(expenseCategories[2].name, 650.0), // Salud
      MapEntry(expenseCategories[4].name, 550.0), // Servicios
      MapEntry('Otros', 350.0),
    ];

    return expenseData.asMap().entries.map((entry) {
      final int index = entry.key;
      final String category = entry.value.key;
      final double value = entry.value.value;
      
      // Color basado en la categoría
      Color color;
      if (index < expenseCategories.length) {
        color = expenseCategories.firstWhere(
          (c) => c.name == category, 
          orElse: () => expenseCategories.last,
        ).color;
      } else {
        color = Colors.grey;
      }

      return PieChartSectionData(
        color: color,
        value: value,
        title: '',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    // Ejemplo de datos, en una aplicación real estos vendrían de un proveedor o servicio
    final List<MapEntry<String, double>> expenseData = [
      MapEntry(expenseCategories[0].name, 850.0), // Alimentación
      MapEntry(expenseCategories[1].name, 450.0), // Transporte
      MapEntry(expenseCategories[2].name, 650.0), // Salud
      MapEntry(expenseCategories[4].name, 550.0), // Servicios
      MapEntry('Otros', 350.0),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: expenseData.asMap().entries.map((entry) {
        final int index = entry.key;
        final String category = entry.value.key;
        final double value = entry.value.value;
        
        // Color y porcentaje
        Color color;
        if (index < expenseCategories.length) {
          color = expenseCategories.firstWhere(
            (c) => c.name == category, 
            orElse: () => expenseCategories.last,
          ).color;
        } else {
          color = Colors.grey;
        }
        
        final double total = expenseData.fold(0, (sum, item) => sum + item.value);
        final double percentage = (value / total) * 100;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
} 