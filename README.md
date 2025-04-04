# flutter_application_unipass

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Para el nombre de la aplicación:
```
flutter pub run change_app_package_name: main com.irvingdesarrolla.UNIPASS
```

Para el icono de la aplicacion:
```
flutter pub run flutter_launcher_icons
```

Para cambiar el splash creen:
```
flutter pub run flutter_native_splash:create
```

Android ABB
```
flutter build appbundle
```
Considerar que por cada Bundle que se genene vamos tenemos que cambiar la version del proyecto el los siguientes archivos:
- android/app/build.gradle
- android/local.propities
- pubspec.yaml