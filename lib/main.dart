import 'package:flutter_application_unipass/utils/imports.dart'; // Asegúrate de importar correctamente todos los archivos necesarios

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniPass ULV',
      initialRoute: Preview1.routeName,
      routes: {
        Preview1.routeName: (context) => const Preview1(),
        Preview2.routeName: (context) => const Preview2(),
        LoginApp.routeName: (context) => const LoginApp(),
        NewAccountAuthentication.routeName: (context) =>
            const NewAccountAuthentication(),
        VerificationNewAccount.routeName: (context) =>
            const VerificationNewAccount(),
        NewAccountCredentials.routeName: (context) =>
            const NewAccountCredentials(),
        AuthenticationPassword.routeName: (context) =>
            const AuthenticationPassword(),
        VerificationPassword.routeName: (context) =>
            const VerificationPassword(),
        CreateNewPassword.routeName: (context) => const CreateNewPassword(),
        HomeStudentScreen.routeName: (context) => HomeStudentScreen(),
        MenuScreen.routeName: (context) => MenuScreen(),
        NotificationsScreen.routeName: (context) => NotificationsScreen(),
        ExitStudent.routeName: (context) => ExitStudent(),
        HelpFAQUser.routeName: (context) => HelpFAQUser(),
        DocumentStudent.routeName: (context) => DocumentStudent(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        CreateExitScreen.routeName: (context) =>
            CreateExitScreen(initialDate: DateTime.now()),
        ExitDetailScreen.routeName: (context) => ExitDetailScreen(),
        EditExitScreen.routeName: (context) => EditExitScreen(),
        HomeScreenStudent.routeName: (context) => HomeScreenStudent(),
        PrivacyUserScreen.routeName: (context) => PrivacyUserScreen(),
        SupportUserScreen.routeName: (context) => SupportUserScreen(),
        ChangepasswordStudent.routeName: (context) => ChangepasswordStudent(),
        DocumentAddStudent.routeName: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return DocumentAddStudent(
            documentName: args['documentName'],
            isUploaded: args['isUploaded'],
            initialFileName: args['fileName'],
          );
        },
        HomeScreenPreceptor.routeName: (context) => HomeScreenPreceptor(),
        HomePreceptorScreen.routeName: (context) => HomePreceptorScreen(),
      },
    );
  }
}
