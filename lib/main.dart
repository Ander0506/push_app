import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/config/theme/app_theme.dart';
import 'package:push_app/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:push_app/presentation/widgets/notifications/handle_notification_interactions.dart';
import 'package:push_app/config/local_notifications/local_notidications.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  // Recibir push notifications en modo bacgraound
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Inicialización de configuración de push notifications
  await NotificationsBloc.initializeFCM();

  // Inicialización de configuración de local notifications
  await LocalNotidications.initializeLocalNotifications();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotificationsBloc(
          requestLocalNotificaionPermissions: LocalNotidications.requestPermissionLocalNotifications,
          showLocalNotification: LocalNotidications.showLocalNotification
        ))
      ],
      child: const MainApp()
    )
  );
}  

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      builder: (context, child) => HandleNotificationInteractions(child: child!),
    );
  }
}
