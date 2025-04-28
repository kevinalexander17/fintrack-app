import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/providers/auth_provider.dart';
import 'package:fintrack/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de perfil
            _buildProfileSection(context, authProvider),
            const SizedBox(height: 24),
            
            // Sección de apariencia
            _buildSectionTitle(context, 'Apariencia'),
            _buildSettingItem(
              context: context,
              icon: Icons.dark_mode,
              title: 'Tema Oscuro',
              subtitle: 'Cambiar entre tema claro y oscuro',
              trailing: Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
            
            // Sección de moneda
            _buildSectionTitle(context, 'Moneda'),
            _buildSettingItem(
              context: context,
              icon: Icons.currency_exchange,
              title: 'Moneda Predeterminada',
              subtitle: 'Soles (S/.)',
              onTap: () {
                // Mostrar diálogo para cambiar moneda
              },
            ),
            
            // Sección de notificaciones
            _buildSectionTitle(context, 'Notificaciones'),
            _buildSettingItem(
              context: context,
              icon: Icons.notifications,
              title: 'Notificaciones',
              subtitle: 'Gestionar notificaciones de la aplicación',
              onTap: () {
                // Navegar a configuración de notificaciones
              },
            ),
            _buildSettingItem(
              context: context,
              icon: Icons.notifications_active,
              title: 'Recordatorios de Pagos',
              subtitle: 'Recibir alertas de pagos pendientes',
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Cambiar configuración de recordatorios
                },
              ),
            ),
            
            // Sección de exportación
            _buildSectionTitle(context, 'Datos'),
            _buildSettingItem(
              context: context,
              icon: Icons.upload_file,
              title: 'Exportar Datos',
              subtitle: 'Exportar datos a Excel o PDF',
              onTap: () {
                // Mostrar opciones de exportación
              },
            ),
            _buildSettingItem(
              context: context,
              icon: Icons.backup,
              title: 'Copia de Seguridad',
              subtitle: 'Guardar tus datos en la nube',
              onTap: () {
                // Mostrar opciones de copia de seguridad
              },
            ),
            
            // Sección de ayuda
            _buildSectionTitle(context, 'Ayuda'),
            _buildSettingItem(
              context: context,
              icon: Icons.help,
              title: 'Centro de Ayuda',
              subtitle: 'Preguntas frecuentes y soporte',
              onTap: () {
                // Navegar a centro de ayuda
              },
            ),
            _buildSettingItem(
              context: context,
              icon: Icons.privacy_tip,
              title: 'Política de Privacidad',
              onTap: () {
                // Mostrar política de privacidad
              },
            ),
            _buildSettingItem(
              context: context,
              icon: Icons.description,
              title: 'Términos de Servicio',
              onTap: () {
                // Mostrar términos de servicio
              },
            ),
            
            // Sección de cuenta
            _buildSectionTitle(context, 'Cuenta'),
            _buildSettingItem(
              context: context,
              icon: Icons.exit_to_app,
              title: 'Cerrar Sesión',
              textColor: Colors.red,
              onTap: () async {
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
            
            // Información de la versión
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'FinTrack v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.currentUser;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user?.displayName?.isNotEmpty == true 
                  ? user!.displayName!.substring(0, 1).toUpperCase() 
                  : 'U',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName ?? 'Usuario',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'usuario@example.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navegar a editar perfil
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: subtitle != null 
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            )
          : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
} 