import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/providers/auth_provider.dart';
import 'package:fintrack/providers/theme_provider.dart';
import 'package:fintrack/screens/auth/login_screen.dart';
import 'package:fintrack/screens/home/dashboard_screen.dart';
import 'package:fintrack/screens/transactions/transactions_screen.dart';
import 'package:fintrack/screens/accounts/accounts_screen.dart';
import 'package:fintrack/screens/settings/settings_screen.dart';
import 'package:fintrack/constants/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoggingOut = false;
  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionsScreen(),
    const AccountsScreen(),
    const SettingsScreen(),
  ];

  Future<void> _confirmLogout(BuildContext context) async {
    if (_isLoggingOut) return; // Evita múltiples intentos
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoggingOut = true;
      });
      
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      try {
        await authProvider.logout();
        if (!mounted) return;
        
        // Usamos pushAndRemoveUntil para limpiar la pila de navegación
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false, // Esto elimina todas las rutas previas
        );
      } catch (e) {
        // Solo mostrar error si todavía está montado
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Ha ocurrido un problema al cerrar sesión. Por favor, inténtalo de nuevo.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
          // Resetear el estado
          setState(() {
            _isLoggingOut = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinTrack'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Cerrar sesión',
            onPressed: _isLoggingOut ? null : () => _confirmLogout(context),
          ),
        ],
      ),
      body: _isLoggingOut 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cerrando sesión...'),
                ],
              ),
            )
          : _screens[_currentIndex],
      floatingActionButton: _currentIndex == 1 && !_isLoggingOut
          ? FloatingActionButton(
              onPressed: () {
                // Navegar a la pantalla de añadir transacción
              },
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.primaryColor,
        onTap: _isLoggingOut 
            ? null 
            : (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Resumen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transacciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Cuentas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
} 
} 