import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  // Firebase Options para android
  static String apiKeyAndroid = dotenv.env['API_KEY_ANDROID'] ?? 'No existe apiKey';
  static String appIdAndroid = dotenv.env['API_ID_ANDROID'] ?? 'No existe appId';
  static String messagingSenderIdAndroid = dotenv.env['MESSAGING_SENDER_ID_ANDROID'] ?? 'No existe messagingSenderId';
  static String projectIdAndroid = dotenv.env['PROJECT_ID_ANDROID'] ?? 'No existe projectId';
  static String storageBucketAndroid = dotenv.env['STORAGE_BUCKET_ANDROID'] ?? 'No existe storageBucket';

  // Firebase Options para IOS
  static String apiKeyIOS = dotenv.env['API_KEY_IOS'] ?? 'No existe apiKey';
  static String appIdIOS = dotenv.env['API_ID_IOS'] ?? 'No existe appId';
  static String messagingSenderIdIOS = dotenv.env['MESSAGING_SENDER_ID_IOS'] ?? 'No existe messagingSenderId';
  static String projectIdIOS = dotenv.env['PROJECT_ID_IOS'] ?? 'No existe projectId';
  static String storageBucketIOS = dotenv.env['STORAGE_BUCKET_IOS'] ?? 'No existe storageBucket';
  static String iosBundleIdIOS = dotenv.env['IOS_BUNDLE_ID_IOS'] ?? 'No existe iosBundleId';
  
}