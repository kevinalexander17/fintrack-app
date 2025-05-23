# FinTrack - Aplicación de Gestión Financiera Personal

FinTrack es una aplicación móvil de gestión financiera personal desarrollada con Flutter y Firebase, diseñada específicamente para usuarios en Perú.

## Características

- Registro e inicio de sesión con correo/contraseña y Google
- Seguimiento de ingresos, gastos y transferencias
- Categorización de transacciones
- Informes y estadísticas financieras
- Interfaz de usuario intuitiva y fácil de usar
- Modo oscuro/claro
- Seguridad con Firebase Authentication y Firestore

## Tecnologías Utilizadas

- **Flutter**: Framework para desarrollo de aplicaciones móviles
- **Firebase**: Plataforma de desarrollo de aplicaciones
  - Authentication: Gestión de usuarios
  - Firestore: Base de datos en tiempo real
  - Analytics: Análisis de uso
- **Provider**: Gestión de estado
- **FL Chart**: Visualización de datos
- **Intl**: Internacionalización

## Requisitos Previos

- Flutter 3.3.0 o superior
- Dart 2.18.0 o superior
- Firebase CLI
- Cuenta de Google (para Firebase)

## Configuración

### 1. Configuración de Firebase

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Configura Firebase Authentication y habilita los proveedores:
   - Correo electrónico/contraseña
   - Google
3. Configura Firestore Database y aplica las reglas de seguridad
4. Descarga y agrega el archivo `google-services.json` en `android/app/`
5. Actualiza las huellas SHA-1 en la configuración del proyecto Firebase

### 2. Instalación de Dependencias

```bash
flutter pub get
```

### 3. Configuración de Google Sign-In

Para la autenticación con Google:
1. Configura el OAuth Consent Screen en Google Cloud Console
2. Añade la huella SHA-1 de tu aplicación a Firebase
3. Asegúrate de que la configuración de Google Sign-In esté correctamente implementada

## Ejecución del Proyecto

```bash
flutter run
```

## Estructura del Proyecto

```
fintrack/
├── lib/
│   ├── constants/       # Constantes y temas
│   ├── models/          # Modelos de datos
│   ├── providers/       # Gestión de estado con Provider
│   ├── screens/         # Pantallas de la aplicación
│   ├── services/        # Servicios (Firebase, etc.)
│   ├── utils/           # Utilidades
│   ├── widgets/         # Widgets reutilizables
│   └── main.dart        # Punto de entrada
├── assets/              # Recursos (imágenes, fuentes, etc.)
└── ...
```

## Reglas de Seguridad de Firestore

Las reglas de seguridad garantizan que los usuarios solo puedan acceder a sus propios datos:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Función para verificar si el usuario está autenticado
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Función para verificar si el documento pertenece al usuario actual
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    // Reglas para usuarios
    match /users/{userId} {
      allow read, write: if isAuthenticated() && isOwner(userId);
    }
    
    // Reglas para transacciones
    match /transactions/{transactionId} {
      allow read, write: if isAuthenticated() && 
                         resource.data.userId == request.auth.uid;
    }
  }
}
```

## Contribución

1. Fork del repositorio
2. Crea una nueva rama (`git checkout -b feature/nueva-caracteristica`)
3. Commit de tus cambios (`git commit -m 'Agrega nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

## Licencia

Este proyecto está licenciado bajo la Licencia MIT.
