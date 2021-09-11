
import 'package:shared_preferences/shared_preferences.dart';


class LocalStorage
{

  static Future<String> getLastNotesNotificationId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('lastNotesNotificationId');
  }

  static Future<void> saveLastNotesNotificationId(String id) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('lastNotesNotificationId', id);
  }

  static Future<String> getLastTaskNotificationId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('lastTaskNotificationId');
  }

  static Future<void> saveLastTaskNotificationId(String id) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('lastTaskNotificationId', id);
  }

}
