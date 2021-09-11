import 'dart:async';

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
import 'package:zonota/notifications/received_notification.dart';
import 'package:zonota/pages/home_container.dart';
import 'package:zonota/pages/login_page.dart';

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
        _askPermissions();
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

