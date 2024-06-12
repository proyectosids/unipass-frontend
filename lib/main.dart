import 'package:flutter_application_unipass/utils/imports.dart';

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
        //ProfileScreen.routeName: (context) => ProfileScreen(),
        ExitStudent.routeName: (context) => ExitStudent(),
        HelpFAQUser.routeName: (context) => HelpFAQUser(),
        DocumentStudent.routeName: (context) => DocumentStudent(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        CreateExitScreen.routeName: (context) => CreateExitScreen(
              initialDate: DateTime.now(),
            ),
        ExitDetailScreen.routeName: (context) => ExitDetailScreen(),
        EditExitScreen.routeName: (context) => EditExitScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        PrivacyuserScreen.routeName: (context) => PrivacyuserScreen(),
        SupportUserScreen.routeName: (context) => SupportUserScreen(),
        ChangepasswordStudent.routeName: (context) => ChangepasswordStudent(),
      },
    );
  }
}
