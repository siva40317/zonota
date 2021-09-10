import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:zonota/common/storage.dart';
import 'package:zonota/models/TaskModel.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/pages/splash_screen.dart';

import 'common/colors.dart';
import 'common/global.dart';
import 'notifications/ReminderNotification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

String selectedNotificationPayload;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final int helloAlarmID = 1;
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
  await AndroidAlarmManager.oneShot(const Duration(seconds:10), helloAlarmID, printHello,rescheduleOnReboot:true,
    exact: true,
    wakeup: true,);
}

void printHello() {
  listenToNotifications();
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zonota',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: AppColors.colorFromHex(AppColors.primary)
      ),
      home: SplashScreen(),
    );
  }
}

void handleNotifications() async
{
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('logo');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (
          int id,
          String title,
          String body,
          String payload,
          ) async {
        didReceiveLocalNotificationSubject.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      });
  const MacOSInitializationSettings initializationSettingsMacOS =
  MacOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectedNotificationPayload = payload;
        selectNotificationSubject.add(payload);
      });
}

 listenToNotifications()
async {


    try
    {
      await Firebase.initializeApp();
      if( FirebaseAuth.instance.currentUser!=null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        Query reference = firestore.collection('notes').where('receivers',arrayContains:FirebaseAuth.instance.currentUser.uid)
            .orderBy('modifiedTime',descending:true);

      reference.snapshots().listen((querySnapshot) async {
         if(querySnapshot.docChanges.isNotEmpty) {
           NotesModel notesModel = NotesModel.fromJson(querySnapshot?.docChanges?.first?.doc?.data());

           if (notesModel?.id !=
               await LocalStorage.getLastNotesNotificationId()) {
             _showNotification((getNameByContactNumber(notesModel?.creatorPhone)??notesModel?.creatorPhone)+" Shared you Note",notesModel.title);
           }
           LocalStorage.saveLastNotesNotificationId(notesModel?.id ?? "id");
         }
           });


        Query reference1 = firestore.collection('tasks').where('assigneeId',isEqualTo:FirebaseAuth.instance.currentUser.uid)
            .orderBy('modifiedTime',descending:true);

        reference1.snapshots().listen((querySnapshot) async {
          if(querySnapshot.docChanges.isNotEmpty) {
            TaskModel notesModel = TaskModel.fromJson(querySnapshot?.docChanges?.first?.doc?.data());
            if(notesModel.creatorId!=FirebaseAuth.instance.currentUser.uid) {
              if (notesModel?.id !=
                  await LocalStorage.getLastTaskNotificationId()) {
                _showNotification((getNameByContactNumber(notesModel?.creatorPhone)??notesModel?.creatorPhone)+" Assigned You A Task",notesModel.title);
              }
              LocalStorage.saveLastTaskNotificationId(notesModel?.id ?? "id");
            }
          }
        });
           }

    }
    catch(e)
  {
    print(e);
  }

}


_showNotification(title,content) async {
  handleNotifications();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, title, content, platformChannelSpecifics,
      payload: 'item x');
}





