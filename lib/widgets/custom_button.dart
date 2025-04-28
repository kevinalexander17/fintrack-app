import 'package:flutter/material.dart';
import 'package:fintrack/constants/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final IconData? icon;
  final Widget? customIcon;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50.0,
    this.borderRadius = 8.0,
    this.icon,
    this.customIcon,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Definir el estilo del botón según el tipo (relleno u outline)
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            side: BorderSide(
              color: backgroundColor ?? AppTheme.primary,
              width: 1.5,
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: backgroundColor ?? AppTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppTheme.primary,
            foregroundColor: textColor ?? Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          );
    
    // Contenido del botón (texto, ícono o indicador de carga)
    Widget buttonContent;
    
    if (isLoading) {
      // Indicador de carga
      buttonContent = SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined 
                ? (backgroundColor ?? AppTheme.primary)
                : (textColor ?? Colors.white),
          ),
        ),
      );
    } else {
      // Texto con ícono opcional
      if (icon != null || customIcon != null) {
        buttonContent = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (customIcon != null)
              customIcon!
            else if (icon != null)
              Icon(icon, size: 20),
            SizedBox(width: icon != null || customIcon != null ? 8 : 0),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      } else {
        // Solo texto
        buttonContent = Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        );
      }
    }
    
    // Construir el botón según el tipo
    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          );
    
    // Aplicar ancho personalizado si se proporciona
    if (width != null) {
      return SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }
    
    // Botón de ancho completo por defecto
    return SizedBox(
      width: double.infinity,
      height: height,
      child: button,
    );
  }
} 