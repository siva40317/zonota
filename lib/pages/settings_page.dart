
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/common/image_asset.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/pages/splash_screen.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:new AppBar(
            backgroundColor:Colors.white,
            toolbarHeight:SizeConfig.height(12),
            elevation:0,
            title:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                SizedBox(height:SizeConfig.height(1),),

                Text("Zonota",style:TextStyle(fontSize:SizeConfig.h5,color:AppColors.colorFromHex(AppColors.primary))),
                SizedBox(height:SizeConfig.height(1),),

                Text("Notes  & Tasks",style:TextStyle(fontSize:SizeConfig.t1,color:AppColors.colorFromHex(AppColors.grey900))),
                SizedBox(height:SizeConfig.height(1),),

              ],)

        ),
        body:Container(
          height:SizeConfig.fitheight(100),
          color:Colors.white,
      child:SingleChildScrollView(
        child:
        Column(
           children: <Widget>[
             Divider(),
             SizedBox(height: SizeConfig.height(2)),

             CircleAvatar(
                 backgroundColor:AppColors.colorFromHex(AppColors.primary),
                 radius:SizeConfig.height(20),
                 child:Image.asset(ImageAsset.logo)),
             SizedBox(height: SizeConfig.height(2)),
             Divider(),
             ListTile(
               title:Text("User"+FirebaseAuth.instance.currentUser.uid.substring(0,10)),
               leading:Icon(Icons.account_circle_rounded),
             ),

             ListTile(
               title:Text(FirebaseAuth.instance.currentUser.phoneNumber),
               leading:Icon(Icons.phone),
             ),

             Divider(),
             ListTile(
               onTap:() async
               {
               await  FirebaseAuth.instance.signOut();
               Navigator.pushReplacement
                   (
                   context,
                   PageRouteBuilder(
                     pageBuilder: (c, a1, a2) => SplashScreen(),
                     transitionsBuilder: (c, anim, a2, child) =>
                         FadeTransition(opacity: anim, child: child),
                     transitionDuration: Duration(milliseconds: 300),
                   ),
                 );
               },
               title:Text("Logout"),
               leading:Icon(Icons.logout),
             ),
             SizedBox(height: 20,),

            






           ],
        ),
      )
    ));
  }




}