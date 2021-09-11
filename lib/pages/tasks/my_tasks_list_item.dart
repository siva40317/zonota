import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/common/common_constant.dart';
import 'package:zonota/common/global.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/task_model.dart';
import 'package:zonota/pages/tasks/task_detail_page.dart';

class MyTasksListItem extends StatefulWidget {
  @required final TaskModel data;
  MyTasksListItem({Key key, this.data}) : super(key: key);

  @override
  _MyTasksListItemState createState() => _MyTasksListItemState();
}

class _MyTasksListItemState extends State<MyTasksListItem> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(

        onTap:()
    {
      Navigator.push(context, new MaterialPageRoute(builder:(context)=>TaskDetailPage(
        taskModel:widget.data,type:0,
      )));
    },child:Container(
      padding: EdgeInsets.all(SizeConfig.width(5)),
      margin: EdgeInsets.all(SizeConfig.size(1)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.size(5))
      ),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          SizedBox(height:SizeConfig.height(1),),
          getTitteView(),
          SizedBox(height:SizeConfig.height(2),),
          getContentView(),
          Divider(),
          SizedBox(height:SizeConfig.height(1),),
          getAssignedView(),
          SizedBox(height:SizeConfig.width(1),),
          getInfoView(),
          SizedBox(height:SizeConfig.width(3),),
          getProgressView(),

        ],
      ),
    ));
  }

  getTitteView()
  {
    return Container(child:Text(widget.data.title,style:TextStyle(color:Colors.grey,fontWeight:FontWeight.w900,
        fontSize:SizeConfig.h6),));
  }

  getContentView()
  {
    return  Container(child:Text(widget.data.content,style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
        fontSize:SizeConfig.t1),));
  }

  getAssignedView()
  {
    return  Container(child:Text("Assigned To ",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
        fontSize:SizeConfig.s1),));
  }

  getInfoView()
  {
    return Row(children: [

      Icon(Icons.account_circle_rounded),
      SizedBox(width:SizeConfig.fitwidth(2),),
      Expanded(child:Text(FirebaseAuth.instance.currentUser.uid == widget.data.assigneeId?
      "ME":getNameByContactNumber(widget?.data?.assigneePhone),style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
          fontSize:SizeConfig.t1),)),

      SizedBox(width:SizeConfig.fitwidth(5),),
      Container(child:Text(CommonConstant.timeAgoSinceDate(widget?.data?.modifiedTime)??"",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
          fontSize:SizeConfig.s1),))
    ],);
  }

  getProgressView()
  {
    return Container(
      width:SizeConfig.width(100),
      height:SizeConfig.height(3),
      decoration:BoxDecoration(
          color:AppColors.colorFromHex(AppColors.grey100),
          borderRadius:BorderRadius.circular(SizeConfig.width(20))
      ),
      child:ClipRRect(
          borderRadius:BorderRadius.circular(SizeConfig.width(20)),
          child:Stack(
            alignment:Alignment.centerLeft,
            children: [
              Container(
                width:SizeConfig.width(widget.data.progress>14?(widget.data.progress)-14.00:widget.data.progress.toDouble()),
                decoration:BoxDecoration(
                    color:getStatusColor(),
                    borderRadius:BorderRadius.circular(SizeConfig.width(20))
                ),),
              Container(
                  alignment:Alignment.center,
                  width:SizeConfig.width(100),
                  child:Text(getStatus(),style:TextStyle(color:getTextColor()),))
            ],
          )),

    );
  }
  getStatus()
  {
    switch(widget.data.status)
    {
      case 0:return "To Do";
      case 1:return "In Progress " +widget.data.progress.toString()+" %";
      case 2:return  "Completed";
    }
  }
  
  getStatusColor()
  {
    switch(widget.data.status)
    {
      case 0:return AppColors.colorFromHex(AppColors.grey100);
      case 1:return Colors.blue;
      case 2:return Colors.green;
    }
  }

  getTextColor()
  {
    switch(widget.data.status)
    {
      case 0:return Colors.black;
      case 1:return widget.data.progress>73?Colors.white:Colors.black;
      case 2:return Colors.white;
    }
  }
}