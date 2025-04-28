import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fintrack/constants/app_theme.dart';
import 'package:fintrack/constants/expense_categories.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedPeriod = 'Este mes';
  final List<String> _periods = ['Hoy', 'Esta semana', 'Este mes', 'Este año', 'Todo'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildPeriodDropdown(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // Mostrar filtros adicionales
                  },
                  icon: const Icon(Icons.filter_list),
                ),
                IconButton(
                  onPressed: () {
                    // Mostrar opciones de búsqueda
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          
          // Lista de transacciones
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 10, // Ejemplo con 10 transacciones
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                // Mockup de datos para el ejemplo
                final bool isIncome = index % 3 == 0;
                final double amount = isIncome 
                    ? (index + 1) * 500.0 
                    : -(index + 1) * 100.0;
                final DateTime date = DateTime.now()
                    .subtract(Duration(days: index * 2));
                
                final categoryIndex = index % expenseCategories.length;
                final category = isIncome 
                    ? 'Ingresos' 
                    : expenseCategories[categoryIndex].name;
                final description = isIncome 
                    ? 'Salario' 
                    : 'Gasto ${index + 1}';
                final color = isIncome 
                    ? AppTheme.positiveColor 
                    : expenseCategories[categoryIndex].color;
                final icon = isIncome 
                    ? Icons.attach_money 
                    : expenseCategories[categoryIndex].icon;
                
                return _buildTransactionItem(
                  context,
                  category,
                  description,
                  amount,
                  date,
                  color,
                  icon,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de añadir transacción
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPeriodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          items: _periods.map((String period) {
            return DropdownMenuItem<String>(
              value: period,
              child: Text(period),
            );
          }).toList(),
          onChanged: (String? value) {
            if (value != null) {
              setState(() {
                _selectedPeriod = value;
              });
            }
          },
        ),
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
    final dateFormatter = DateFormat('dd MMM, yyyy', 'es_PE');
    
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