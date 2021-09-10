
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/pages/create_task_page.dart';
import 'package:zonota/pages/notes/my_notes_page.dart';
import 'package:zonota/pages/notes/notes_list_item.dart';
import 'package:zonota/pages/notes/recieved_notes_page.dart';
import 'package:zonota/pages/tasks/assigned_tasks_page.dart';
import 'package:zonota/pages/tasks/my_tasks_page.dart';

import 'create_notes_page.dart';


class TasksPage extends StatefulWidget {


  TasksPage({Key key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  var width;
  var selected = 0;
  
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
                  child:selected==0?MyTasksPage():AssignedTasksPage(),
                ),
              )
            ],
          ),
        )
    );
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
            selected:selected==1, label:Text("Assigned Tasks",style:TextStyle(color:selected==1?Colors.white:Colors.black),),

            onSelected:(value) {setState(() {selected=1;});}
        ),
      ],
    );
  }

  
}