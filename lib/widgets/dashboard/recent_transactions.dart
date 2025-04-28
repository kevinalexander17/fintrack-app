import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fintrack/constants/app_theme.dart';
import 'package:fintrack/constants/expense_categories.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

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
                'Transacciones Recientes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navegar a la pantalla de todas las transacciones
                },
                child: const Text('Ver todas'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Lista de transacciones recientes (mockup)
          _buildTransactionItem(
            context,
            'Alimentación',
            'Mercado Wong',
            -120.50,
            DateTime.now().subtract(const Duration(days: 1)),
            expenseCategories[0].color,
            expenseCategories[0].icon,
          ),
          const Divider(),
          _buildTransactionItem(
            context,
            'Transporte',
            'Uber',
            -25.00,
            DateTime.now().subtract(const Duration(days: 2)),
            expenseCategories[1].color,
            expenseCategories[1].icon,
          ),
          const Divider(),
          _buildTransactionItem(
            context,
            'Salario',
            'Empresa ABC',
            2500.00,
            DateTime.now().subtract(const Duration(days: 5)),
            Colors.green,
            Icons.work,
          ),
          const Divider(),
          _buildTransactionItem(
            context,
            'Servicios',
            'Recibo de luz',
            -85.30,
            DateTime.now().subtract(const Duration(days: 7)),
            expenseCategories[4].color,
            expenseCategories[4].icon,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    String category,
    String description,
    double amount,
    DateTime date,
    Color color,
    IconData icon,
  ) {
    final bool isIncome = amount > 0;
    final formatter = NumberFormat.currency(locale: 'es_PE', symbol: 'S/. ');
    final dateFormatter = DateFormat('dd MMM', 'es_PE');
    
    return InkWell(
      onTap: () {
        // Navegar al detalle de la transacción
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            // Icono de categoría
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // Información de la transacción
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Monto y fecha
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatter.format(amount.abs()),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isIncome ? AppTheme.positiveColor : AppTheme.negativeColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormatter.format(date),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 