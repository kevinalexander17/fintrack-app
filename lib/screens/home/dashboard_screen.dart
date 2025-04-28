import 'package:flutter/material.dart';
import 'package:fintrack/constants/app_theme.dart';
import 'package:fintrack/widgets/dashboard/balance_card.dart';
import 'package:fintrack/widgets/dashboard/expense_summary.dart';
import 'package:fintrack/widgets/dashboard/recent_transactions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                // Aquí se actualizarán los datos
                await Future.delayed(const Duration(milliseconds: 1500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tarjeta de balance
                    const BalanceCard(
                      totalBalance: 3540.50,
                      currency: 'S/.',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Resumen de ingresos y gastos mensuales
                    Container(
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
                          const Text(
                            'Resumen Mensual',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              // Ingresos
                              Expanded(
                                child: _buildSummaryItem(
                                  context,
                                  'Ingresos',
                                  'S/. 4,200.00',
                                  Icons.arrow_upward,
                                  AppTheme.positiveColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Gastos
                              Expanded(
                                child: _buildSummaryItem(
                                  context,
                                  'Gastos',
                                  'S/. 2,850.50',
                                  Icons.arrow_downward,
                                  AppTheme.negativeColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Balance
                          _buildSummaryItem(
                            context,
                            'Balance',
                            'S/. 1,349.50',
                            Icons.account_balance_wallet,
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Resumen de gastos por categoría
                    const ExpenseSummary(),
                    
                    const SizedBox(height: 24),
                    
                    // Transacciones recientes
                    const RecentTransactions(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 