import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
       
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Inicializar Firebase
        FirebaseApp.configure()

        // Registrar notificaciones locales
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }

        // Configurar Firebase Messaging
        Messaging.messaging().delegate = self

        // Registrar notificaciones push
        application.registerForRemoteNotifications()

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Registrar el APNs Token para Firebase
    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("📲 APNs Token registrado: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken

        // Forzar la actualización del token de Firebase cuando se obtiene el APNs Token
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ Error obteniendo FCM Token: \(error.localizedDescription)")
            } else if let token = token {
                print("✅ FCM Token actualizado: \(token)")
            }
        }
    }

    // Método para recibir el Token de Firebase Cloud Messaging (FCM)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔥 FCM Token recibido: \(fcmToken ?? "No token")")
    }
}