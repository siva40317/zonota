
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/common/global.dart';
import 'package:zonota/common/storage.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/TaskModel.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/notifications/ReminderNotification.dart';
import 'package:zonota/pages/create_task_page.dart';
import 'package:zonota/pages/tasks/my_tasks_list_item.dart';



class MyTasksPage extends StatefulWidget {


  MyTasksPage({Key key}) : super(key: key);

  @override
  _MyTasksPageState createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {

  var width;

  var selected =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      floatingActionButton:new FloatingActionButton(
        backgroundColor:AppColors.colorFromHex(AppColors.primary),
        onPressed:()
        {
           Navigator.push(context, new MaterialPageRoute(builder:(context)=>CreateTaskPage()));

        },
        child:Icon(Icons.add),
      ),
      appBar:new AppBar(
        backgroundColor:Colors.white,
        toolbarHeight:SizeConfig.height(15),
          elevation:0,
        title:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
          Text("Tasks",style:TextStyle(fontSize:SizeConfig.h5,color:AppColors.colorFromHex(AppColors.primary))),
            SizedBox(height:SizeConfig.height(1),),
          getChips()
        ],)

       ),

    body:Container(

      height:SizeConfig.fitheight(100,safe: false),
      child: Column
        (
        children: <Widget>[
          Container(

            alignment:Alignment.center,

            child:Column(
              children: [


              ],
            ),
          ),
          Expanded(
            child:Container(
              child: myTaskList(),
            ),
          )
        ],
      ),
    )
    );
  }


 Widget myTaskList()
  {
    return Container(

      child:
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tasks').where('creatorId',isEqualTo:FirebaseAuth.instance.currentUser.uid)
              .orderBy('modifiedTime',descending:true).snapshots(),
          builder: (context,snapshot){
            if (snapshot.hasError || snapshot?.data?.docs?.length==0) {
              return Container(
                alignment:Alignment.center,
                height:SizeConfig.height(100),
                child:Text('No Data')
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment:Alignment.center,
                height:SizeConfig.height(100),
                child:CircularProgressIndicator(

                ),
              );
            }


            return ListView.builder(
              itemCount:snapshot.data.docs.length,
              itemBuilder: (context,index){
                return MyTasksListItem(data:TaskModel.fromJson( snapshot.data.docs[index].data()));
              },
            );
          }));

  }




  getChips()
  {
    return Row(
      children: [

        ChoiceChip(
            selectedColor:AppColors.colorFromHex(AppColors.primary),
            selected:selected==0, label:Text("My Tasks",style:TextStyle(color:selected==0?Colors.white:Colors.black),),
            onSelected:(value) {setState(() {selected=0;});}
        ),
        SizedBox(width:SizeConfig.width(1),),
        ChoiceChip(  selectedColor:AppColors.colorFromHex(AppColors.primary),
            selected:selected==1, label:Text("Recieved Tasks",style:TextStyle(color:selected==1?Colors.white:Colors.black),),

            onSelected:(value) {setState(() {selected=1;});}
        ),
      ],
    );
  }


  



}