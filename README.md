<<<<<<< HEAD
# UniPassULV
Proyecto de desarrollo móvil para la gestión de salidas y entrada de la Universidad Linda Vista
=======
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
flutter pub run change_app_package_name:main com.irvingdesarrolla.UNIPASS
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

# 📘 Documentación Técnica – Modelos de Datos

Este documento describe los modelos de datos utilizados en la aplicación móvil UniPass.

---

## 🧱 Modelo: `Authorization`

Representa una autorización de permiso gestionada por un empleado.

| Campo           | Tipo    | Descripción                         |
|-----------------|---------|-------------------------------------|
| idAuthorize     | int     | Identificador de la autorización    |
| idEmpleado      | int     | ID del empleado que autoriza        |
| noDepto         | int     | Número del departamento             |
| idPermission    | int     | ID del permiso asociado             |
| statusAuthorize | String  | Estado de la autorización           |

---

## 🧱 Modelo: `Notification`

Modelo para notificaciones locales o remotas.

| Campo   | Tipo    | Descripción                    |
|---------|---------|--------------------------------|
| title   | String  | Título de la notificación      |
| body    | String  | Cuerpo de la notificación      |
| dataId  | String  | Identificador de datos asociado|

---

## 🧱 Modelo: `PaginatedPermissions`

Modelo para manejar permisos paginados desde la API.

| Campo        | Tipo             | Descripción                    |
|--------------|------------------|--------------------------------|
| permissions  | List<Permission> | Lista de permisos              |
| totalItems   | int              | Total de permisos              |
| totalPages   | int              | Número total de páginas        |
| currentPage  | int              | Página actual                  |
| limit        | int              | Límite por página              |

---

## 🧱 Modelo: `Permission`

Contiene la información completa de una solicitud de salida de un alumno.

Incluye datos del permiso, del alumno, trabajo, tutor y contacto.

_(**Ver tabla completa en documento extendido por complejidad del modelo**)._

---

## 🧱 Modelo: `Student`

Representa los datos personales de un alumno.

| Campo              | Tipo     | Descripción                        |
|--------------------|----------|------------------------------------|
| matricula          | String   | Matrícula del alumno               |
| nombre             | String   | Nombre del alumno                  |
| apellidos          | String   | Apellidos del alumno               |
| residencia         | String   | Residencia del alumno              |
| fechaNacimiento    | DateTime | Fecha de nacimiento                |
| sexo               | String   | Sexo                               |
| edad               | int      | Edad del alumno                    |
| telFijo            | String   | Teléfono fijo                      |
| celular            | String   | Teléfono celular                   |
| correoPersonal     | String   | Correo personal                    |
| correoInstitucional| String   | Correo institucional               |
| pais               | String   | País                               |
| estado             | String   | Estado                             |
| ciudad             | String   | Ciudad                             |
| direccion          | String   | Dirección                          |
| cp                 | String   | Código postal                      |
| curp               | String   | CURP                               |
| nivelAcademico     | String   | Nivel académico                    |
| campus             | String   | Campus asignado                    |
| nombreEscuela      | String   | Nombre oficial de la escuela       |
| cursoEscolar       | String   | Curso escolar                      |

---

## 🧱 Modelo: `Tutor`

Información del tutor del alumno.

| Campo     | Tipo    | Descripción                |
|-----------|---------|----------------------------|
| nombre    | String  | Nombre del tutor           |
| apellidos | String  | Apellidos del tutor        |
| telefono  | String  | Teléfono fijo del tutor    |
| direccion | String  | Dirección completa         |
| país      | String  | País del tutor             |
| estado    | String  | Estado del tutor           |
| ciudad    | String  | Ciudad del tutor           |
| cp        | String  | Código postal              |
| celular   | String  | Celular del tutor          |
| correo    | String  | Correo electrónico         |

---

## 🧱 Modelo: `Work`

Datos del departamento y jefe asignado.

| Campo              | Tipo    | Descripción                        |
|--------------------|---------|------------------------------------|
| idDepto            | int     | ID del departamento                |
| nombreDepartamento | String  | Nombre del departamento            |
| idJefe             | int     | ID del jefe de departamento        |
| jefeDepartamento   | String  | Nombre del jefe de departamento    |

---

## 🧱 Modelo: `Employee`

Datos personales y administrativos de un empleado (preceptor o jefe de departamento).

| Campo               | Tipo     | Descripción                       |
|---------------------|----------|-----------------------------------|
| matricula           | int      | Matrícula del empleado            |
| campus              | String   | Campus asignado                   |
| nombres             | String   | Nombre del empleado               |
| apellidos           | String   | Apellidos del empleado            |
| fechaNacimiento     | DateTime | Fecha de nacimiento               |
| edad                | int      | Edad                              |
| sexo                | String   | Sexo                              |
| celular             | String   | Teléfono celular                  |
| emailInstitucional  | String   | Correo institucional              |
| idDepartamento      | int      | ID del departamento               |
| departamento        | String   | Nombre del departamento           |

---

## 🧱 Modelo: `UserData`

Contenedor general para el usuario autenticado.

| Campo     | Tipo               | Descripción                         |
|-----------|--------------------|-------------------------------------|
| students  | List<Student>      | Lista de alumnos                    |
| type      | String             | Tipo de usuario (Alumno, Empleado)  |
| tutors    | List<Tutor>        | Lista de tutores                    |
| works     | List<Work>         | Lista de trabajos                   |
| employees | List<Employee>     | Lista de empleados                  |


# 🔧 Documentación Técnica – Servicios HTTP (API Clients)

Este documento describe los servicios implementados para consumir la API REST del proyecto UniPass, utilizando `http` y `SharedPreferences`.

---

## 📁 AuthServices

- `authenticateUser(matricula, correo, contrasena)`: Login de usuario.
- `getUserInfo(userId)`: Obtener datos básicos del usuario.
- `UserInfoExt(userId)`: Obtener información extendida del usuario.
- `userInfoDelegado(userId)`: Obtener datos de delegado.
- `updatePassword(correo, nuevaContrasena)`: Actualizar contraseña.
- `getinfoMatricula(matricula)`: Consultar datos de usuario por matrícula.
- `buscarpersona(nombre)`: Buscar usuario por nombre.
- `updateTokenFCM(matricula, tokenFCM)`: Guardar token de notificación.
- `searchTokenFCM(matricula)`: Consultar token FCM.
- `updateDocumentStatus(matricula, statusDoc)`: Actualizar estatus de documentación.

---

## 📁 AuthorizeService

- `asignarAuthorice(...)`: Asignar una autorización nueva.
- `asignarPreceptor(...)`: Obtener ID del preceptor según sexo y nivel académico.
- `obtenerStatus(...)`: Consultar estatus de autorización.
- `valorarAuthorize(...)`: Modificar estatus de autorización.
- `fetchAuthorizations(idPermiso)`: Obtener todas las autorizaciones asociadas a un permiso.

---

## 📁 BedroomService

- `obtenerDormitorio(nivelAcademico, sexo)`: Retorna el ID del dormitorio correspondiente.

---

## 📁 ChecksService

- `solicitarCreacionChecks(...)`: Crear registros de punto de control.
- `obtenerChecksDormitorio(id)`: Lista de checks pendientes por dormitorio.
- `obtenerChecksDormitorioFin(id)`: Checks de regreso.
- `obtenerChecksVigilancia()`: Checks pendientes en vigilancia.
- `actualizarEstadoCheck(...)`: Cambiar estado del check.

---

## 📁 DocumentService

- `uploadDocument(file, idDocumento, idUser)`: Subir documento del usuario.
- `uploadProfile(file, idDocumento, idUser)`: Subir imagen de perfil.
- `getProfile(idUser, idDocumento)`: Obtener imagen de perfil.
- `getDocuments()`: Obtener todos los tipos de documentos disponibles.
- `getDocumentsByUser(userId)`: Documentos subidos por un usuario.
- `getDocument(id)`: Detalle de un documento específico.
- `deleteDocument(idUser, idDocumento)`: Eliminar documento del usuario.
- `getExpedientesPorDormitorio(idDormi)`: Obtener resumen de expedientes por dormitorio.
- `getArchivosAlumno(dormitorio, nombre, apellidos)`: Archivos de un alumno.

---

## 📁 LocalNotification

- `initializeLocalNotifications()`: Configurar notificaciones locales.
- `showLocalNotification(...)`: Mostrar notificación individual.
- `showGroupSummaryNotification(...)`: Mostrar resumen de grupo de notificaciones.

---

## 📁 NotificationService

- `showNotification(...)`: Mostrar notificación individual agrupada.
- `showGroupSummaryNotification(...)`: Mostrar resumen de grupo.
- `sendNotificationToServer(...)`: Enviar notificación vía backend a FCM.

---

## 📁 OtpServices

Servicios para autenticación OTP vía Syswork:

- `loginOTP()`: Inicia sesión y guarda token OTP.
- `launchOTP(correo)`: Envía OTP por correo.
- `verificationOTP(otp, correo)`: Verifica OTP ingresado.
- `forgotOTP(correo)`: OTP para recuperación de contraseña.
- `resetPassword(...)`: Restablecer contraseña con OTP.

---

## 📁 PermissionService

- `getPermissions(...)`: Obtener permisos paginados.
- `cancelPermission(id, userId)`: Cancelar permiso existente.
- `createPermission(...)`: Crear solicitud de permiso y notificar.
- `getPermissionForAutorizacion(...)`: Obtener permisos para empleados.
- `getPermissionForAutorizacionPrece(...)`: Permisos pendientes para preceptor.
- `terminarPermission(...)`: Valorar permiso como finalizado.
- `getTopPermissionsByUser(userId)`: Últimos permisos del alumno.
- `getTopPermissionsByPreceptor()`: Últimos permisos por preceptor.
- `getTopPermissionsByEmployee()`: Últimos permisos por jefe de departamento.

---

## 📁 PointCheckService

- `getPoints(idPermiso)`: Obtener puntos de control de un permiso.

---

## 📁 RegisterService

- `getDatosUser(userId)`: Datos del usuario desde la base de datos externa ULV.
- `getPreceptor(noDepto)`: Retorna ID del preceptor asignado.
- `getValidarJefe(idEmpleado)`: Valida si el usuario es jefe.
- `getJefeVigilancia(idEmpleado)`: Verifica si es jefe de vigilancia.
- `registerUser(userData)`: Registrar nuevo usuario.
- `getEncargadoDepto(noDepto)`: Obtener jefe de departamento.
- `getCordinador(matricula)`: Obtener coordinador académico.

---

## 📁 UserCheckersService

- `buscarChecker(correo)`: Buscar usuario checker.
- `cambiarActividad(id, status, matricula)`: Activar/desactivar checker.
- `deleteChecker(id)`: Eliminar checker.

---

📌 Todos los servicios utilizan `http` y manejo de errores básicos. Los endpoints son definidos dinámicamente a través de `config/config_url.dart`.


# Documentación de Pantallas - UniPass App

Este documento describe el flujo de pantallas y sus funcionalidades principales dentro del módulo de autenticación de la aplicación **UniPass** desarrollada con Flutter.

---

## 📱 Pantallas de Introducción

### `Preview1`
- Presenta el nombre del sistema.
- Muestra la imagen: `assets/image/presentacion-1.svg`.
- Explica brevemente qué es UniPass.
- Botón "Continuar" navega a `Preview2` con animación.

### `Preview2`
- Segunda introducción con la imagen: `assets/image/presentacion-2.svg`.
- Explica el medio de implementación (dispositivo móvil).
- Pregunta si el usuario está listo.
- Botón "Continuar" marca la app como abierta por primera vez (`isFirstTime`) y redirige a `LoginApp`.

---

## 🔐 Pantalla de Inicio de Sesión

### `LoginApp`
- Pantalla principal para iniciar sesión.
- Muestra logo de la universidad y slogan.
- Permite recuperar contraseña (`AuthenticationPassword`) o crear cuenta nueva (`NewAccountAuthentication`).
- Usa `LoginTextFields` para el formulario de autenticación.
- Implementa confirmación antes de salir de la app (`WillPopScope`).

### `LoginTextFields`
- Campos:
  - Matrícula/Correo.
  - Contraseña.
- Validación de formulario.
- Llama a `AuthServices.authenticateUser`.
- Manejo de token FCM y almacenamiento en `SharedPreferences`.
- Redirección por tipo de usuario (`ALUMNO`, `PRECEPTOR`, `DEPARTAMENTO`, etc.).

---

## 🔁 Recuperación de Contraseña

### `AuthenticationPassword`
- Solicita matrícula para buscar el correo institucional.
- Llama a `OtpServices.forgotOTP`.
- Navega a `VerificationPassword`.

### `VerificationPassword`
- Recibe correo como argumento.
- Muestra input para código OTP (4 dígitos).
- Navega a `CreateNewPassword` con el código OTP.

### `CreateNewPassword`
- Solicita nueva contraseña y confirmación.
- Llama a `OtpServices.resetPassword`.
- Si es válida, actualiza la contraseña mediante `AuthServices.updatePassword`.
- Muestra diálogo de éxito y redirige al login.

---

## 🆕 Registro de Nueva Cuenta

### `NewAccountAuthentication`
- Solicita matrícula.
- Obtiene correo institucional desde `RegisterService`.
- Llama a `OtpServices.launchOTP`.
- Navega a `VerificationNewAccount`.

### `VerificationNewAccount`
- Recibe el correo y matrícula.
- Verifica OTP ingresado con `OtpServices.verificationOTP`.
- Si es válido, navega a `ConfirmDataUser`.

### `ConfirmDataUser`
- Muestra información del estudiante o empleado (nombre, correo, tutor, jefe de departamento).
- Si es válido (alumno interno o empleado autorizado), permite continuar.
- Llama nuevamente a `OtpServices.launchOTP` y navega a `NewAccountCredentials`.

### `NewAccountCredentials`
- Solicita y valida contraseña.
- Asigna tipo de usuario basado en reglas específicas.
- Determina dormitorio usando `BedroomService`.
- Llama a `RegisterService.registerUser`.
- Muestra diálogo de éxito.

## 🏠 `HomeStudentScreen`

Pantalla principal de bienvenida para el estudiante. Muestra las salidas recientes y permite acceder a la pantalla de gestión de salidas.

- **Ruta:** `/homeStudent`
- **Componentes clave:**
  - `AppBar` con nombre del estudiante.
  - Lista de permisos recientes.
  - Botón para acceder a `ExitStudent`.

---

## 📋 `ExitStudent`

Pantalla que muestra la lista de permisos solicitados por el alumno, filtrables por fecha. También permite crear un nuevo permiso y eliminar permisos pendientes.

- **Ruta:** `/ExitStudent`
- **Funciones principales:**
  - Mostrar permisos con paginación.
  - Crear nueva salida.
  - Cancelar salidas pendientes.
  - Navegar a detalles con `ExitDetailScreen`.

---

## ➕ `CreateExitScreen`

Formulario para crear una solicitud de salida. El tipo de salida y día permitido dependen del sexo del estudiante. Se envía a la API y actualiza la lista de permisos.

- **Ruta:** `/createExit`
- **Validaciones:**
  - Solo permite "Pueblo" en días específicos por sexo.
  - Fecha de regreso solo visible en algunos tipos.
- **Servicios involucrados:** `PermissionService`, `AuthServices`.

---

## 🔍 `ExitDetailScreen`

Pantalla que muestra el detalle de una salida, incluyendo datos del alumno, tipo de salida, fechas, estatus y la barra de progreso con pasos de autorización.

- **Ruta:** `/exitDetail`
- **Componentes clave:**
  - Visualización dinámica del progreso de autorizaciones.
  - Información detallada de la salida.
  - Botón para cerrar la vista.

---

## 📂 `DocumentStudent`

Muestra el estado de la documentación requerida para habilitar la funcionalidad de salidas. Permite abrir cada documento para subirlo o eliminarlo.

- **Ruta:** `/documentStudent`
- **Documentos requeridos:**
  - INE del Tutor
  - Reglamento Dormitorio
  - Convenio de Salidas

---

## 📎 `DocumentAddStudent`

Permite seleccionar y subir un documento específico. También permite removerlo. Se guarda el estado en `SharedPreferences`.

- **Ruta:** `/documentAddStudent`
- **Campos relevantes:**
  - Nombre del documento
  - Estado (adjunto o no adjunto)
  - Archivo seleccionado

---

## 🔐 `ChangepasswordStudent`

Pantalla para iniciar el flujo de cambio de contraseña usando OTP. Recupera el correo por matrícula y lo utiliza para enviar el OTP.

- **Ruta:** `/changeStudent`
- **Servicios usados:** `OtpServices`, `AuthServices`

---

## ⚙️ `MenuScreen`

Pantalla de menú principal del estudiante, que permite acceder a funcionalidades como Documentos, Salidas y Soporte.

- **Ruta:** `/menu`
- **Accesibilidad:**
  - Solo habilita el acceso a `Salidas` si la documentación está completa.

---

## 👤 `ProfileScreen`

Pantalla de perfil del estudiante donde puede:
- Cambiar su contraseña
- Ver su foto de perfil
- Acceder a soporte y privacidad
- Cerrar sesión

- **Ruta:** `/profileStudent`
- **Interacción con imagen:** usa `DocumentService` para subir/actualizar la imagen.

---

## 🔐 `PrivacyUserScreen` & `SupportUserScreen`

Pantallas informativas:
- `PrivacyUserScreen`: muestra políticas de privacidad y un enlace externo.
- `SupportUserScreen`: muestra canales de soporte y botón a manual de usuario.

---

## 🔄 `HomeScreenStudent`

Contenedor de navegación inferior (`BottomNavigationBar`) que conecta:
1. `HomeStudentScreen`
2. `MenuScreen`
3. `ProfileScreen`

- **Ruta:** `/homeStudentMenu`

## `HomeScreenPreceptor`
Pantalla principal que integra el sistema de navegación por pestañas para los preceptores:
- **Inicio:** `HomePreceptorScreen`
- **Menú:** `MenuPreceptorScreen`
- **Perfil:** `ProfileScreen(userType: 'PRECEPTOR')`

---

## `HomePreceptorScreen`
Pantalla de bienvenida al preceptor que muestra:
- Nombre y apellidos del preceptor desde `SharedPreferences`.
- Solicitudes recientes de permisos de salida de sus estudiantes.
- Botón de acceso directo a **Historial de Autorizaciones**.

---

## `MenuPreceptorScreen`
Menú de opciones del preceptor:
- **Salidas** (`/AuthorizationPreceptor`)
- **Ayuda**
- **Documentos**
- **Checks**
- **Delegar**

Diseñado con `GridView` para navegación rápida a las funcionalidades clave.

---

## `HistoryPermissionAuthorization`
Historial filtrable de permisos de salida autorizables:
- Filtrado por fecha.
- Muestra solicitudes asociadas al preceptor y a sus delegados (si aplica).
- Acceso al detalle completo del permiso.

---

## `InfoPermissionDetail`
Detalle completo del permiso de salida:
- Información del alumno, tutor, tipo de salida y fechas.
- Muestra la barra de progreso de autorizaciones (`ProgressBar dinámico`).
- Permite aprobar o rechazar solicitudes.
- Notificaciones automáticas vía FCM a siguientes autorizadores o al alumno.
- Creación de puntos de chequeo (`Checks`) si el permiso es aprobado.

---

## `FileOfDocuments` y `DocumentListScreen`
Pantalla para el preceptor donde puede:
- Consultar expedientes/documentos de estudiantes bajo su supervisión.
- Buscar por nombre completo.
- Visualizar archivos PDF directamente o abrir otros formatos con URL externa.

---

## `DelegatePositionScreen`
Permite al preceptor delegar su cargo temporalmente:
- Buscar persona por nombre.
- Asignar, activar o eliminar una delegación.
- Notificaciones automáticas al delegado.
- Validaciones de activación única por cargo.

---

## `HomeEmployeeScreen`
- Muestra un saludo personalizado al preceptor.
- Recupera las últimas solicitudes de salida realizadas por los alumnos.
- Permite redirigir a la pantalla completa de autorizaciones.
- Soporta `RefreshIndicator`.

## `MenuEmployeeScreen`
- Pantalla de menú para empleados.
- Ofrece accesos a:
  - Autorización de salidas (`/AuthorizationEmployee`)
  - Centro de ayuda (`/helpUser`)
  - Gestión de checkers (si el usuario es de vigilancia)
  - Delegación (si el usuario tiene un jefe o es vigilancia)

## `PermissionAuthorizationEmployee`
- Pantalla para ver y autorizar solicitudes de salida por fecha.
- Filtrado por día utilizando un `DatePicker`.
- Agrupa solicitudes tanto propias como delegadas.
- Acceso al detalle completo de cada permiso.

## `HomeScreenEmployee`
- Controla el flujo de navegación entre:
  - `HomeEmployeeScreen`
  - `MenuEmployeeScreen`
  - `ProfileScreen`
- Verifica la validez del token JWT al reanudar la app.

## `HelpFAQUser`
- Pantalla FAQ con respuestas a preguntas comunes.
- Contiene botones de navegación rápida y lista de `ExpansionTiles`.

## `HomeDepartament`
- Interfaz para personal del departamento o vigilancia.
- Visualiza los "checks" (salidas y retornos) de estudiantes.
- Confirmación o cancelación de asistencia con observaciones.
- Soporta `RefreshIndicator`.

## `HomeScreenDepartament`
- Controlador de navegación entre:
  - `HomeDepartament`
  - `HelpFAQUser`
  - `ProfileScreen`

## `CreateProfileChecks`
- Gestión de usuarios tipo checker.
- Permite visualizar, eliminar y refrescar los usuarios existentes.

## `CreateUserChecks`
- Formulario completo para crear un nuevo checker.
- Campos requeridos: nombre, apellidos, género, celular, matrícula, contraseña, y dormitorio.
- Valida y registra el usuario a través del servicio `RegisterService`.


## ✅ Utilidades

- **Responsive**: Todas las pantallas utilizan `Responsive` para escalar widgets proporcionalmente.
- **TextFieldWidget**: Widget reutilizable para campos de texto estilizados.

---

## 🛠️ Servicios Utilizados

- `AuthServices`: Autenticación, tokens, y actualización de contraseña.
- `OtpServices`: Generación y verificación de OTP.
- `RegisterService`: Obtención de datos de usuario y registro de nuevos usuarios.
- `BedroomService`: Determinación del dormitorio basado en sexo y nivel académico.

---

## 🧠 Observaciones

- Se siguen buenas prácticas de navegación y seguridad.
- Las rutas están definidas como constantes estáticas (`routeName`) para facilitar el manejo.
- El flujo OTP cubre tanto recuperación como creación de cuenta.





# 📱 Manual de Despliegue de Aplicación Flutter – Android

Autor: **Irving Yael Patricio González**

---

## 📑 Tabla de Contenido

- [Preparación del Proyecto (Android)](#preparación-del-proyecto-android)
  - [Cambiar Bundle ID](#cambiar-bundle-id)
  - [Creación de llaves Release y Upload](#creación-de-llaves-release-y-upload)
  - [Creación del App Bundle (AAB)](#creación-del-app-bundle-aab)
- [Publicación del Proyecto (Android)](#publicación-del-proyecto-android)
  - [Android Developer Console](#android-developer-console)
  - [Configuración de prueba cerrada](#configuración-de-prueba-cerrada)

---

## 📦 Preparación del Proyecto (Android)

Este manual tiene como objetivo guiarte en los pasos necesarios para preparar tu proyecto Flutter finalizado hasta la generación de un App Bundle (AAB) para su publicación en la Google Play Store. Antes de continuar, asegúrate de que tu aplicación funciona correctamente, ha sido probada y se han corregido posibles errores. Esto es crucial para evitar problemas que impidan la generación exitosa del App Bundle. Además, es fundamental verificar la compatibilidad de las herramientas utilizadas en el proyecto, ya que pueden surgir conflictos con ciertas versiones. Un caso común es la versión del JDK, que debe ser compatible con otras herramientas clave del entorno de desarrollo. Algunos de los documentos y configuraciones que pueden verse afectados por incompatibilidades incluyen:

• Versión de Kotlin
• Versión de Build Gradle y Gradle
• Versión del compilador SDK

Es posible que surjan otros problemas durante el proceso de despliegue. Como ingeniero, deberás aplicar tus habilidades y conocimientos para identificar y solucionar cualquier conflicto o inconveniente que pueda afectar el proyecto. Verificar y actualizar correctamente las herramientas y configuraciones garantizará un proceso de despliegue sin errores y facilitará una publicación exitosa en la tienda de aplicaciones.

### ⚙ Cambiar Bundle ID
Es importante saber que nosotros no podemos desplegar la aplicación en la Play Store o en la App Store si tiene un Bundle ID por defecto, en el caso de nuestro proyecto podemos verificar este dato podemos ir al MainActivity.kt de nuestro proyecto. 

Para poder cambiar dicho Bundle ID del proyecto, podemos realizarlo de 2 formas:

1. Cambiar de forma manual cada una de las referencias del Bundle ID que viene por default de nuestro proyecto por el
nuevo que vayamos ha asignar.
2. De forma semiautomática utilizando una paquetería de pub.dev llamada change_app_package_name la cual cambia todas o la mayoría de las coincidencias del Bundle ID en nuestro proyecto

En el caso de esta guía vamos utilizar el segundo método para agilizar el proceso usando la paqueteia de flutter pud.dev:
“change_app_package_name”. 
Donde instalaremos la dependencia de desarrollo en nuestro archivo
pubspec.yaml:

Evita usar el Bundle ID por defecto (`com.example...`). Para cambiarlo, puedes:

1. Cambiar manualmente todas las referencias del ID.
2. Usar la herramienta: `change_app_package_name`.

```bash
dart run change_app_package_name:main com.tuempresa.tuapp
```

---

### 🔐 Creación de Llaves Release y Upload

Una vez hayas creado tu cuenta en Google Play Console y realizado el pago correspondiente, es fundamental firmar digitalmente tu aplicación antes de subirla a la Play Store. Esta firma se realiza mediante un archivo llamado keystore, que funciona como una especie de huella digital única que identifica al desarrollador. El archivo keystore garantiza que todas las actualizaciones futuras provienen del mismo autor. Este archivo debe ser resguardado con mucho cuidado, ya que si se pierde, no podrás actualizar la aplicación existente en la Play Store, y será necesario volver a subir la app como una nueva publicación (perdiendo usuarios, reseñas y posicionamiento).

- ¿Cómo generar el keystore?

No es necesario estar dentro del proyecto Flutter o Android para crear el keystore. Simplemente abre una terminal (o símbolo del
sistema) y ejecuta el siguiente comando:

keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA - keysize 2048 -validity 10000 -alias upload

Este comando crea un archivo llamado upload-keystore.jks en tu carpeta personal (~). Te pedirá completar información como:
• Contraseña del keystore
• Nombre del propietario
• Nombre de la organización
• Ubicación y país

- ¿Dónde guardar el keystore?

Guárdalo en un lugar seguro y haz una copia de respaldo. Puedes crear una carpeta dentro de tu proyecto llamada /keystore/ y mover ahí el archivo generado, aunque se recomienda no subirlo a ningún repositorio como GitHub.

CREACION DEL APP BUNDLE (AAB)
1. Abre una terminal en el directorio raíz del proyecto Flutter
2. Comando para generar el AAB (recomendado por Google Play):
```bash
flutter build appbundle
```
3. El archivo generado se guarda en:
```bash
build/app/outputs/bundle/release/app-release.aab
```
El archivo generado ya estará firmado si configuraste correctamente el archivo key.properties y build.gradle (como se indicó en el paso de firma digital).
NOTA: Considerar que por cada Bundle que se genene vamos tenemos que cambiar la version del proyecto el los siguientes archivos:
- android/app/build.gradle
- android/local.propities
- pubspec.yaml

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```


## 🚀 Publicación del Proyecto (Android)

Una vez creada y configurada la cuenta de desarrollador en Google Play Console, el siguiente paso es registrar la aplicación que se desea publicar. Para ello, se deben seguir estos pasos:
1. Acceder a la consola desde https://play.google.com/console con la cuenta de desarrollador.
2. Hacer clic en el botón “Crear aplicación”.
3. Completar los siguientes campos obligatorios:
    a. Nombre de la aplicación: Este será el nombre visible en Google Play. Debe ser representativo, claro y único.
    b. Idioma predeterminado: Seleccionar el idioma principal que usará la aplicación (por ejemplo, español – México).
    c. Tipo de aplicación: Seleccionar si se trata de una “Aplicación” o un “Juego”.
    d. Gratis o de pago: Indicar si la app será gratuita o tendrá un costo. Nota: una aplicación marcada como gratuita no puede convertirse en de pago posteriormente.
4. Leer y aceptar las políticas del programa para desarrolladores.
5. Hacer clic en “Crear” para finalizar el registro inicial. Después de este paso, se habilita el panel de configuración general donde se podrá cargar el paquete de la app y completar la información restante. Antes de poder lanzar una versión al público, Google Play Console exige que se completen varios apartados de información sobre la aplicación. A continuación se describen los principales:

- Ficha de la tienda (Store Listing)

Esta sección contiene la información que será visible para los usuarios en la Play Store. Debe incluir:

- Nombre de la aplicación
- Descripción breve (máximo 80 caracteres)
- Descripción completa (hasta 4,000 caracteres)
- Capturas de pantalla:
- Mínimo 2 para dispositivos móviles.
- Opcional: capturas para tablets, Android TV o Wear OS si aplica.
- Ícono de la app: formato PNG (512 x 512 px, máximo 1 MB).
- Imagen destacada (opcional): usada para promocionar la app.
- Categoría: seleccionar la categoría principal (por ejemplo, Educación, Herramientas).
- Detalles de contacto: correo electrónico obligatorio, sitio web y teléfono opcionales.

- Clasificación de contenido 
    
Para obtener la clasificación de edad adecuada, se debe completar un cuestionario sobre el tipo de contenido que ofrece la app. Al finalizar, Google asigna automáticamente una clasificación (por ejemplo, “Todos”, “Adolescentes”, etc.).

- Política de privacidad

Es obligatorio incluir una URL válida hacia un documento de política de privacidad que explique cómo se recopilan y usan los datos de los usuarios. Esta URL debe estar alojada en un sitio web accesible públicamente.

- Acceso a la aplicación

Se debe indicar si toda la funcionalidad de la app está disponible libremente o si requiere acceso restringido (como un login). Si hay restricciones, se deberá proporcionar acceso a los revisores de Google mediante cuentas de prueba.

- Configurar una prueba cerrada en google play console

1. Accede a tu proyecto en Google Play Console
    
    a. Ve a https://play.google.com/console
    b. Selecciona la aplicación que deseas probar.

2. Ve a la sección “Pruebas”

    a. En el menú lateral, selecciona:
    b. “Versión” > “Pruebas” > “Prueba cerrada”
    c. Haz clic en “Crear nueva versión” (si aún no tienes una).

3. Crea una lista de testers.

Tienes dos opciones:
    a. Mediante correo electrónico: Crea una lista de usuarios añadiendo sus correos Gmail (uno por línea).
    b. Mediante grupo de Google o lista de correo: Puedes utilizar un grupo de Google para organizar a los testers.

    NOTA: Todos los testers deben tener una cuenta de Google (Gmail) y estar registrados en la Play Store.

4. Carga el archivo .AAB
    
    a. Ve a “Versión cerrada” > “Crear versión”
    b. Sube el archivo .aab generado en Flutter o Android Studio.
    c. Añade una nota de versión (changelog).
    d. Presiona “Guardar”, luego “Revisar y lanzar”.

5. Publica la prueba cerrada

    a. Revisa que toda la información requerida esté completa(Ficha de Play Store, clasificación, política de privacidad, etc.).
    b. Haz clic en “Enviar para revisión”.
    c. Una vez aprobado, Google te proporcionará un enlace de invitación para que los testers puedan unirse.

6. Comparte el enlace con los testers
    a. Google Play generará un enlace como este:
    Ejemplo:
    https://play.google.com/apps/testing/com.tuempresa.tuapp
    b. Comparte ese enlace con los testers. Ellos deberán:
    c. Aceptar la invitación.
    d. Descargar la app desde la Play Store.

7. Recoge retroalimentación

    a. Puedes pedir a tus testers que envíen comentarios por email o mediante un formulario.
    b. También puedes activar la opción para recibir reportes automáticos de errores desde los dispositivos de prueba.

8. Transición a producción 
Una vez validado que la app funciona correctamente:

    a. Ve a “Versión” > “Producción”
    b. Haz clic en “Crear versión”, sube el .aab final, y repite el proceso para lanzar la aplicación al público general.


📌 **Nota:** Esta guía se enfoca solo en Android. El despliegue en iOS está pendiente.
>>>>>>> master
