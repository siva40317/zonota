


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/TaskModel.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/repositories/repository.dart';

class CreateNotePage extends StatefulWidget {
  CreateNotePage({Key key}) : super(key: key);

  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {

  var title="";
  var content="";
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:new AppBar(
        elevation:0,
        title:Text("Add New Note"),
      ),
      body:Container(
        color:Colors.white,
        child:SingleChildScrollView(child:Column(
          
          children: [

            SizedBox(height:SizeConfig.height(2),),
            getTitleTextField(),
            SizedBox(height:SizeConfig.height(2),),
            getContentTextField(),
            SizedBox(height:SizeConfig.height(3),),
            getCreateButton()

          ],
        ),

      )),
    );
  }

  getTitleTextField() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.width(5), right: SizeConfig.width(5)),
          child: new Text(
            "Title",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.colorFromHex(AppColors.primary),
              fontSize: 15.0,
            ),
          ),
        ),
        SizedBox(height:SizeConfig.height(1),),
        Container(

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
              onChanged:(value)
              {
                setState(() {
                  title=value;
                });
              },
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                contentPadding:EdgeInsets.all(SizeConfig.width(2)),
                border: InputBorder.none,

                hintText: 'Enter Title',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ))
      ],
    ));

  }

  getContentTextField() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.width(5), right: SizeConfig.width(5)),
              child: new Text(
                "Content",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorFromHex(AppColors.primary),
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(height:SizeConfig.height(1),),
            Container(

              height:SizeConfig.fitheight(60),

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
                  maxLines:100,
                  onChanged:(value)
                  {
                    setState(() {
                      content=value;
                    });
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Content',
                    contentPadding:EdgeInsets.all(SizeConfig.width(2)),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ))
          ],
        ));

  }
  
  getCreateButton()
  {
    return Container(
        width:SizeConfig.width(90),
        height:SizeConfig.height(8),

        child:ElevatedButton(
          style:ElevatedButton.styleFrom(
              elevation:SizeConfig.size(2),
              primary:AppColors.colorFromHex(AppColors.primary)
          ),
          onPressed:title.isNotEmpty&&content.isNotEmpty?()async
      {

          setState(() {
            loading =false;
          });
          var done =  await new RepositoryImpl().addNotes(new NotesModel(
              creatorId:FirebaseAuth.instance.currentUser.uid,
              creatorPhone:FirebaseAuth.instance.currentUser.phoneNumber,
              title:title,content:content,
           createdTime:DateTime.now().millisecondsSinceEpoch,
               modifiedTime:DateTime.now().millisecondsSinceEpoch));
          setState(() {
            loading =true;
          });
          if(done)
            {
              Navigator.pop(context);
            }
          else
            {
              Fluttertoast.showToast(msg: "Error Creating Note");
            }

      }:null,
      child: Text("Create Note",style:TextStyle(color:Colors.white),),
    ));
  }


}