import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fintrack/constants/app_theme.dart';
import 'package:fintrack/models/account.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen de cuentas
              _buildAccountSummary(context),
              const SizedBox(height: 24),
              
              // Sección de cuentas
              const Text(
                'Mis Cuentas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Lista de cuentas (ejemplo con datos mock)
              _buildAccountItem(
                context,
                'Efectivo',
                1250.50,
                'S/.',
                AccountType.cash,
                Colors.green,
                Icons.account_balance_wallet,
              ),
              const SizedBox(height: 12),
              _buildAccountItem(
                context,
                'Cuenta BCP',
                3780.25,
                'S/.',
                AccountType.checking,
                Colors.red,
                Icons.account_balance,
                institutionName: 'Banco de Crédito del Perú',
              ),
              const SizedBox(height: 12),
              _buildAccountItem(
                context,
                'Ahorros BBVA',
                2500.00,
                'S/.',
                AccountType.savings,
                Colors.blue,
                Icons.savings,
                institutionName: 'BBVA',
              ),
              const SizedBox(height: 12),
              _buildAccountItem(
                context,
                'Tarjeta Visa',
                -1200.80,
                'S/.',
                AccountType.creditCard,
                Colors.purple,
                Icons.credit_card,
                institutionName: 'Interbank',
              ),
              const SizedBox(height: 24),
              
              // Sección de inversiones
              const Text(
                'Mis Inversiones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Lista de inversiones (ejemplo con datos mock)
              _buildAccountItem(
                context,
                'Fondo Mutuo',
                5000.00,
                'S/.',
                AccountType.investment,
                Colors.amber,
                Icons.trending_up,
                institutionName: 'Credicorp Capital',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewAccount,
        tooltip: 'Añadir cuenta',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewAccount() {
    // Implementación futura para añadir cuentas
    debugPrint('Añadir nueva cuenta');
  }

  Widget _buildAccountSummary(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            Color(0xFF1976D2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance Total',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'S/. 11,330.00',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Activos
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Activos',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'S/. 12,530.75',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              
              // Pasivos
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'Pasivos',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'S/. 1,200.80',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(
    BuildContext context,
    String name,
    double balance,
    String currency,
    AccountType type,
    Color color,
    IconData icon, {
    String? institutionName,
  }) {
    final formatter = NumberFormat.currency(locale: 'es_PE', symbol: '$currency ');
    final isNegative = balance < 0;
    
    return Container(
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _viewAccountDetails(name),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icono de la cuenta
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Información de la cuenta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (institutionName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          institutionName,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Saldo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatter.format(balance.abs()),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isNegative ? AppTheme.negativeColor : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getAccountTypeLabel(type),
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
        ),
      ),
    );
  }

  void _viewAccountDetails(String accountName) {
    // Implementación futura para ver detalles de cuenta
    debugPrint('Ver detalles de la cuenta: $accountName');
  }

  String _getAccountTypeLabel(AccountType type) {
    // Esta es la mejor práctica para switch con enums en Dart modernos:
    // Usar switch expression garantiza exhaustividad en tiempo de compilación
    return switch (type) {
      AccountType.cash => 'Efectivo',
      AccountType.checking => 'Cuenta Bancaria',
      AccountType.savings => 'Cuenta de Ahorros',
      AccountType.creditCard => 'Tarjeta de Crédito',
      AccountType.investment => 'Inversión',
      AccountType.loan => 'Préstamo',
      AccountType.asset => 'Activo',
      AccountType.debt => 'Deuda',
      AccountType.other => 'Otro'
    };
  }
} 