import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/providers/auth_provider.dart';
import 'package:fintrack/constants/app_theme.dart';
import 'package:fintrack/utils/form_validators.dart';
import 'package:fintrack/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.resetPassword(_emailController.text.trim());
        
        if (!mounted) return;
        
        setState(() {
          _emailSent = true;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _errorMessage = _handleFirebaseAuthError(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  String _handleFirebaseAuthError(String errorMessage) {
    if (errorMessage.contains('user-not-found')) {
      return 'No existe una cuenta con este correo electrónico.';
    } else if (errorMessage.contains('invalid-email')) {
      return 'Correo electrónico inválido.';
    } else {
      return 'Error al enviar el correo de restablecimiento. Por favor, intenta nuevamente.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // Fondo gradiente superior
          Container(
            height: size.height * 0.3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryColor.withOpacity(0.8),
                  AppTheme.primaryColor.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          
          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Botón de retroceso
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  
                  // Título
                  Center(
                    child: Text(
                      'Restablecer contraseña',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Subtítulo
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Te enviaremos un enlace para crear una nueva contraseña',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Contenido principal
                  _emailSent ? _buildSuccessMessage() : _buildResetForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetForm() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icono
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Mensaje de error
            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Formulario
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _emailController,
                    label: 'Correo electrónico',
                    hintText: 'ejemplo@correo.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: FormValidators.validateEmail,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón de enviar
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Enviar enlace',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Nota informativa
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                'Revisa tu bandeja de entrada y sigue las instrucciones del correo para crear una nueva contraseña.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono de éxito
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 60,
                color: Colors.green,
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              '¡Correo enviado!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Hemos enviado un enlace para restablecer tu contraseña a:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              _emailController.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Volver al inicio de sesión',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Si no recibes el correo en unos minutos, revisa tu carpeta de spam.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 