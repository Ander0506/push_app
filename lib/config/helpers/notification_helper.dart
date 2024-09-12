import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper {

  static String getMessageId( RemoteMessage message) {
    return  message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '';
  }
}