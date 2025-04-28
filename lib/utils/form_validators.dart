class FormValidators {
  // Validación de correo electrónico
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu correo electrónico';
    }
    
    // Expresión regular para validar formato de correo
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    
    return null;
  }
  
  // Validación de contraseña
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu contraseña';
    }
    
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }
  
  // Validación para campos requeridos
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio${fieldName != null ? ': $fieldName' : ''}';
    }
    return null;
  }
  
  // Validación para nombres
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu nombre';
    }
    
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    return null;
  }
  
  // Validación de número de teléfono
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // El teléfono puede ser opcional
    }
    
    // Eliminar espacios y guiones para facilitar la validación
    final cleanPhone = value.replaceAll(RegExp(r'[\s-]'), '');
    
    // Validar que solo contiene dígitos
    if (!RegExp(r'^\d+$').hasMatch(cleanPhone)) {
      return 'El número de teléfono solo debe contener dígitos';
    }
    
    // Validar longitud (para Perú, normalmente 9 dígitos)
    if (cleanPhone.length != 9) {
      return 'El número de teléfono debe tener 9 dígitos';
    }
    
    return null;
  }
  
  // Validación para montos
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa un monto';
    }
    
    // Convertir a double para validar
    try {
      final amount = double.parse(value.replaceAll(',', '.'));
      if (amount <= 0) {
        return 'El monto debe ser mayor a 0';
      }
    } catch (e) {
      return 'Ingresa un monto válido';
    }
    
    return null;
  }
  
  // Validación para fechas
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, selecciona una fecha';
    }
    return null;
  }
} 