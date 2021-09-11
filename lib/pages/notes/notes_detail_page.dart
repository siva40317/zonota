import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/notes_model.dart';

class NotesDetailPage extends StatefulWidget {
  @required final NotesModel notesModel;
  NotesDetailPage({Key key, this.notesModel}) : super(key: key);

  @override
  _NotesDetailPageState createState() => _NotesDetailPageState();
}

class _NotesDetailPageState extends State<NotesDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body:getBody(),
    );
  }

  getAppBar()
  {
    return new AppBar(
      iconTheme: IconThemeData(
        color: AppColors.colorFromHex(AppColors.primary), //change your color here
      ),
      backgroundColor:Colors.white,
      elevation:0,
      title:Text(widget.notesModel.title,style:TextStyle(color:AppColors.colorFromHex(AppColors.primary),
          fontWeight:FontWeight.w900),),);
  }

  getBody()
  {
    return Container(
        height:SizeConfig.height(100),
        width:SizeConfig.width(100),
        color:Colors.white,
        padding:EdgeInsets.all(SizeConfig.size(2)),
        child:
        Text(widget.notesModel.content));
  }
}