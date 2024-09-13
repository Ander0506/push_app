import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:push_app/domain/entities/push_message.dart';
import 'package:push_app/firebase_options.dart';
import 'package:push_app/config/helpers/notification_helper.dart';
import 'package:push_app/config/local_notifications/local_notidications.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}


class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {

    on<NotificationStatusChanged>( _notificationsStatusChanged );

    on<NotificationReceived>(_onPushMessageReceived);

    // Verificar el estado de las notificaciones
    _initialStatusCheck();

    //Listener para notificaciones en Foreground
    _onForegroundMessage();

  }

  // Iniciar la configuración de Firebase Cloud Messaging, revisar el archivo firebase?options.dart
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Verificación de si ya se concedieron lois permisos.
  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged( settings.authorizationStatus ));
  }

  // Obtención del Token único del dispositivo
  void _getFCMToken() async {
    if ( state.status != AuthorizationStatus.authorized ) return;

    final token = await messaging.getToken();
    print('Token APP: $token');
  }

  // Gestionador o manejaro de notificaciones
  void handleRemoteMessage( RemoteMessage message ){
    if ( message.notification == null ) return;

    final notificacion = PushMessage(
      messageId: NotificationHelper.getMessageId(message),
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
        ? message.notification!.android?.imageUrl
        : message.notification!.apple?.imageUrl
    );

    LocalNotidications.showLocalNotificaion(
      id: 1,
      title: notificacion.title,
      body: notificacion.body,
      data: notificacion.data.toString()
    );

    add(NotificationReceived(notificacion));
  }

  // Notificaciones en segundo plano
  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen( handleRemoteMessage );
  }

  // Permisos de dispositivo para notificaciones
  void requestPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    // Solicitar permiso a las local notifications
    await LocalNotidications.requestPermissionLocalNotifications();

    add(NotificationStatusChanged( settings.authorizationStatus ));
    
  }

  // ---------- EVENTS ----------

  // Evento la notificar el cambio del estado de la notificación
   void _notificationsStatusChanged( NotificationStatusChanged event, Emitter<NotificationsState> emit ){
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();
  }

  // Evento para notificar el cambio de la información de la lista de notificaciones recibidas
  void _onPushMessageReceived( NotificationReceived event, Emitter<NotificationsState> emit ){
    emit(
      state.copyWith(
        notifications: [ event.notification, ...state.notifications ]
      )
    );
  }

  // Evento para regresar un PushMessage si existe
  PushMessage? getMessageById( String pushMessageId ){
    final exist = state.notifications.any((element) =>  element.messageId == pushMessageId);

    if( !exist ) return null;

    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }

}
