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
        HomeStudentScreen.routeName: (context) => const HomeStudentScreen(),
        MenuScreen.routeName: (context) => const MenuScreen(),
        NotificationsScreen.routeName: (context) => const NotificationsScreen(),
        ExitStudent.routeName: (context) => const ExitStudent(),
        HelpFAQUser.routeName: (context) => const HelpFAQUser(),
        DocumentStudent.routeName: (context) => const DocumentStudent(),
        ProfileScreen.routeName: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return ProfileScreen(userType: args);
        },
        CreateExitScreen.routeName: (context) =>
            CreateExitScreen(initialDate: DateTime.now()),
        ExitDetailScreen.routeName: (context) => const ExitDetailScreen(),
        EditExitScreen.routeName: (context) => const EditExitScreen(),
        HomeScreenStudent.routeName: (context) => const HomeScreenStudent(),
        PrivacyUserScreen.routeName: (context) => const PrivacyUserScreen(),
        SupportUserScreen.routeName: (context) => const SupportUserScreen(),
        ChangepasswordStudent.routeName: (context) =>
            const ChangepasswordStudent(),
        DocumentAddStudent.routeName: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return DocumentAddStudent(
            documentName: args['documentName'],
            isUploaded: args['isUploaded'],
            initialFileName: args['fileName'],
          );
        },
        HomeScreenPreceptor.routeName: (context) => const HomeScreenPreceptor(),
        HomePreceptorScreen.routeName: (context) => const HomePreceptorScreen(),
        NoticesScreenPreceptor.routeName: (context) =>
            const NoticesScreenPreceptor(),
      },
    );
  }
}
