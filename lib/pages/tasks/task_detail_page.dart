import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/common/common_constant.dart';
import 'package:zonota/common/global.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/TaskModel.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/repositories/repository.dart';
import 'package:flutter/services.dart';
class TaskDetailPage extends StatefulWidget {
  @required final type;
  @required final TaskModel taskModel;
  TaskDetailPage({Key key, this.taskModel, this.type}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {

  int progress = 0;
  bool progressMode = false;
  var progressController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:new AppBar(
        iconTheme: IconThemeData(
          color: AppColors.colorFromHex(AppColors.primary), //change your color here
        ),
        backgroundColor:Colors.white,
        elevation:0,
        title:Text("Task Detail",style:TextStyle(color:AppColors.colorFromHex(AppColors.primary),
        fontWeight:FontWeight.w900),),),
      body:Container(
           height:SizeConfig.height(100),
           width:SizeConfig.width(100),
           color:Colors.white,
          padding:EdgeInsets.all(SizeConfig.size(2)),
          child:SingleChildScrollView(
    child:Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [

        Text(widget?.taskModel?.title,style:TextStyle(color:AppColors.colorFromHex(AppColors.primary),
        fontWeight:FontWeight.w900,fontSize:SizeConfig.h6),),
        SizedBox(height:SizeConfig.size(2),),
        Container(child:Text(widget.type==0?"Assigned To ":"Assigned By",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
            fontSize:SizeConfig.s1),)),
        SizedBox(height:SizeConfig.width(1),),
        Row(children: [

          Icon(Icons.account_circle_rounded),
          SizedBox(width:SizeConfig.fitwidth(2),),
          Expanded(child:Text(getAssigneeName(),style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
              fontSize:SizeConfig.t1),)),

          SizedBox(width:SizeConfig.fitwidth(5),),
          Container(child:Text(CommonConstant.timeAgoSinceDate(widget?.taskModel?.modifiedTime)??"",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
              fontSize:SizeConfig.s1),))
        ],),
        SizedBox(height:SizeConfig.size(1),),
        SizedBox(height:SizeConfig.width(2),),
        Container(
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
                    width:SizeConfig.width(widget.taskModel.progress>14?
                    (widget.taskModel.progress)-8.00:widget.taskModel.progress.toDouble()),
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

        ),
        Divider(),
        Row
          (
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
          !progressMode && [0,1].contains(widget.taskModel.status)?getUpdateStatusButton():Container(),
          SizedBox(width:SizeConfig.width(1),),
           progressMode? getProgressTextField():Container(),
            [1].contains(widget.taskModel.status)?getUpdateProgressButton():Container()
        ],),
        Divider(),
        Container(child:Text("Description",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
            fontSize:SizeConfig.s1),)),
        SizedBox(height:SizeConfig.size(1),),
        Text(widget?.taskModel?.content,style:TextStyle(fontSize:SizeConfig.h6),),





      ],),
    )),



    );
  }

  getAssigneeName() {
    if(widget.type==0)
       return FirebaseAuth.instance.currentUser.uid == widget.taskModel.assigneeId?
       "ME":getNameByContactNumber(widget.taskModel.assigneePhone);
    else
      return FirebaseAuth.instance.currentUser.uid == widget.taskModel.creatorId?
      "ME":getNameByContactNumber(widget.taskModel.creatorPhone);
  }


  getStatus()
  {
    switch(widget.taskModel.status)
    {
      case 0:return "To Do";
      case 1:return "In Progress " +widget.taskModel.progress.toString()+" %";
      case 2:return  "Completed";
    }
  }

  getStatusColor()
  {
    switch(widget.taskModel.status)
    {
      case 0:return AppColors.colorFromHex(AppColors.grey100);
      case 1:return Colors.blue;
      case 2:return Colors.green;
    }
  }

  getTextColor()
  {
    switch(widget.taskModel.status)
    {
      case 0:return Colors.black;
      case 1:return widget.taskModel.progress>73?Colors.white:Colors.black;
      case 2:return Colors.white;
    }
  }

  getUpdateStatusButton()
  {
    return Container(
      child:ElevatedButton(
        child:Text(widget.taskModel.status==1?"Update As Completed":"Update As In Progress"),
        onPressed:() async
        {
             int status = widget.taskModel.status==0?1:2;
             await RepositoryImpl().updateProgress(widget.taskModel.id,status==2?100:widget.taskModel.status, status);
             Fluttertoast.showToast(msg: widget.taskModel.status==1?"Status Updated As Completed":"Status Updated As In Progress");
             Navigator.pop(context);
             },
      ),
    );
  }



  getUpdateProgressButton()
  {
    return Container(
      child:ElevatedButton(
        style:ElevatedButton.styleFrom(
          primary:AppColors.colorFromHex(AppColors.primary)
        ),
        child:Text("Update Progress"),
        onPressed:!progressMode ||(progressMode&&progress>0&&progress<=100)?()
        async {
             if(!progressMode)
               {

                 setState(() {
                   progressMode=true;
                 });
               }
             else
               {
                 int status = progress==100?2:widget.taskModel.status;
                 await RepositoryImpl().updateProgress(widget.taskModel.id,progress, status);
                 Fluttertoast.showToast(msg:"Progress Updated");
                 Navigator.pop(context);
               }
        }:null,
      ),
    );
  }

  getProgressTextField() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height:SizeConfig.fitheight(5),
                width:SizeConfig.width(43),

                decoration: BoxDecoration(
                  color:AppColors.colorFromHex(AppColors.whiteSmoke),
                  border: Border(
                    bottom: BorderSide(
                        color: AppColors.colorFromHex(AppColors.primary),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                margin: EdgeInsets.only(left:SizeConfig.width(5),right:SizeConfig.width(5)),
                child: TextField(
                  controller:progressController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]+')),],
                  onChanged:(value)
                  {
                    setState(() {
                      progress=value.isNotEmpty?int.parse(value):0;
                    });
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter 0 - 100',
                    contentPadding:EdgeInsets.all(SizeConfig.width(2)),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ))
          ],
        ));

  }
}