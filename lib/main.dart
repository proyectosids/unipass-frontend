import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_unipass/api/firebase_api.dart';
import 'package:flutter_application_unipass/screen/checkspoint/form_create_user.dart';
import 'package:flutter_application_unipass/screen/preceptor/delegate_user.dart';
import 'package:flutter_application_unipass/services/local_notification.dart';
import 'package:flutter_application_unipass/utils/imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotification.requestPermissionLocalNotifications();
  await FirebaseApi().initNotifications();
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniPass ULV',
      locale: const Locale('es'),
      supportedLocales: const [Locale('en', ''), Locale('es', '')],
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      initialRoute: isFirstTime ? Preview1.routeName : LoginApp.routeName,
      routes: {
        Preview1.routeName: (context) => const Preview1(),
        Preview2.routeName: (context) => const Preview2(),
        LoginApp.routeName: (context) => const LoginApp(),
        NewAccountAuthentication.routeName: (context) =>
            const NewAccountAuthentication(),
        VerificationNewAccount.routeName: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return VerificationNewAccount(userData: args);
        },
        NewAccountCredentials.routeName: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return NewAccountCredentials(userData: args);
        },
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
        ConfirmDataUser.routeName: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return ConfirmDataUser(userId: args);
        },
        HistoryPermissionAuthorization.routeName: (context) =>
            const HistoryPermissionAuthorization(),
        MenuPreceptorScreen.routeName: (context) => const MenuPreceptorScreen(),
        HomeScreenEmployee.routeName: (context) => const HomeScreenEmployee(),
        HomeEmployeeScreen.routeName: (context) => const HomeEmployeeScreen(),
        MenuEmployeeScreen.routeName: (context) => const MenuEmployeeScreen(),
        FileOfDocuments.routeName: (context) => const FileOfDocuments(),
        InfoPermissionDetail.routeName: (context) =>
            const InfoPermissionDetail(),
        PermissionAuthorizationEmployee.routeName: (context) =>
            const PermissionAuthorizationEmployee(),
        CreateProfileChecks.RouteName: (context) => const CreateProfileChecks(),
        HomeScreenDepartament.routeName: (context) =>
            const HomeScreenDepartament(),
        HomeDepartament.routeName: (context) => const HomeDepartament(),
        DelegatePositionScreen.routeName: (context) =>
            const DelegatePositionScreen(),
        CreateUserChecks.RouteName: (context) => const CreateUserChecks(),
      },
    );
  }
}
