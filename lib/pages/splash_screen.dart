import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';
import 'package:zonota/common/app_navigator.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/common/global.dart';
import 'package:zonota/common/image_asset.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/TaskModel.dart';
import 'package:zonota/notifications/ReminderNotification.dart';
import 'package:zonota/pages/home_container.dart';
import 'package:zonota/pages/login_page.dart';
import 'package:zonota/repositories/repository.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

String selectedNotificationPayload;



class SplashScreen extends StatefulWidget  {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Color primary = AppColors.colorFromHex(AppColors.primary);

  @override
  void initState() {
    super.initState();

    init();
    _askPermissions();



  }

  init()
  async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Timer(Duration(seconds: 2), () {
        AppNavigator.replace(context, LoginPage());
      });
    }
    else
      {
      Timer(Duration(seconds: 2), () {

          AppNavigator.replace(context, HomeContainer());
        });
      }

  }







  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(body:Container(
      height: SizeConfig.fitheight(100,safe:false),

      decoration: BoxDecoration(
        color: primary,
       /* image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.8), BlendMode.dstATop),
          image: Image.asset(ImageA), fit: BoxFit.cover,
        ),*/
      ),
      child: new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 250.0),
            child: Center(
              child:Image.asset(ImageAsset.logo,height:SizeConfig.fitheight(30),)
              ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Zo",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.h3,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "NoTa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.h3
                  ),
                ),

              ],
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Text(
                  "Notes & Tasks",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:SizeConfig.h6
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    ));


  }


  @override
  void dispose() {
    super.dispose();
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

  void listenToNotifications()
  {

    if( FirebaseAuth.instance.currentUser!=null)
    {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      Query reference = firestore.collection('users').doc(FirebaseAuth.instance.currentUser.uid).
      collection('sharedNotes');
      reference.snapshots().listen((querySnapshot) {
        querySnapshot.docs.forEach((change) {
          _showNotification();
        });
      });
    }
  }


  Future<void> _showNotification() async {
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
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }



  _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
      myContacts = contacts.where((element) => element.phones.isNotEmpty).toList() ?? [];
      setState(() {

      });
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      Fluttertoast.showToast(msg:'Access to contact data denied');
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      Fluttertoast.showToast(msg:'Contact data not available on device');
    }
  }









}

