
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/task_model.dart';
import 'package:zonota/models/user_model.dart';
import 'package:zonota/pages/choose_contacts_page.dart';
import 'package:zonota/repositories/repository.dart';

class CreateTaskPage extends StatefulWidget {
  CreateTaskPage({Key key}) : super(key: key);

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {

  var title="";
  var content="";
  var loading = false;
  UserModel assignee;
  FocusNode nameFocusNode = new FocusNode();
  FocusNode descFocusNode = new FocusNode();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:new AppBar(
        elevation:0,
        title:Text("Add New Task"),
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
            getAssigneeView(),
            SizedBox(height:SizeConfig.height(3),),
            Container(
              child:Row(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: [
                  getAssignToMeButton(),
                  getChooseAssigneeButton()
                ],
              ),
            ),


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
              focusNode:nameFocusNode,
              autofocus:false,
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
                "Description",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorFromHex(AppColors.primary),
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(height:SizeConfig.height(1),),
            Container(

              height:SizeConfig.fitheight(40),

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
                  maxLines:1000,
                  focusNode:descFocusNode,
                  autofocus:false,
                  onChanged:(value)
                  {
                    setState(() {
                      content=value;
                    });
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Description',
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
      onPressed:title.isNotEmpty&&content.isNotEmpty && assignee!=null && assignee.id.isNotEmpty?()async
      {

          setState(() {
            loading =false;
          });
          var done =  await new RepositoryImpl().addTask(
              new TaskModel(title:title,content:content,
           status:0,progress:0,
           createdTime:DateTime.now().millisecondsSinceEpoch,
               creatorId:FirebaseAuth.instance.currentUser.uid,
               creatorPhone:FirebaseAuth.instance.currentUser.phoneNumber,
               assigneeId:assignee.id,assigneePhone:assignee.phone,
               modifiedTime:DateTime.now().millisecondsSinceEpoch,));
          setState(() {
            loading =true;
          });
          if(done)
            {
              Navigator.pop(context);
            }
          else
            {
              Fluttertoast.showToast(msg: "Error Creating Task");
            }

      }:null,
      child: Text("Create Task",style:TextStyle(color:Colors.white),),
    ));
  }

  getAssignToMeButton()
  {
    return Container(
      child:ElevatedButton(
        style:ElevatedButton.styleFrom(
          primary:AppColors.colorFromHex(AppColors.primary),
          elevation:10
        ),
        onPressed:()
        {
          assignee = new UserModel(id:FirebaseAuth.instance.currentUser.uid,name:"",phone:FirebaseAuth.instance.currentUser.phoneNumber);
          setState(() {

          });
          },
        child:Text("Assign To Me"),
      ),
    );
  }

  getChooseAssigneeButton()
  {
    return Container(
      child:ElevatedButton(
        style:ElevatedButton.styleFrom(
            primary:AppColors.colorFromHex(AppColors.primary),
            elevation:10
        ),
        onPressed:() async
        {
          nameFocusNode.unfocus();
          descFocusNode.unfocus();
          var list = await Navigator.push(context, new MaterialPageRoute(builder:(context)=> ChooseContactsPage(singleChoice:true,)));
          if(list!=null && list.isNotEmpty)
            {
              assignee = list.first;
              setState(() {

              });
            }
        },
        child:Text("Choose Assignee"),
      ),
    );
  }

  getAssigneeView()
  {
   return Container(
       width:SizeConfig.fitwidth(90),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
        Container(child:Text("Assignee :",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
            fontSize:SizeConfig.t1),)),
        SizedBox(width:SizeConfig.fitwidth(2),),
        Icon(Icons.account_circle_rounded),
        SizedBox(width:SizeConfig.fitwidth(2),),
        Expanded(child:Text(getAssigneeName(),style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
            fontSize:SizeConfig.t1),)),
        SizedBox(width:SizeConfig.fitwidth(5),),

      ],)
      ,
    );
  }

  getAssigneeName() {
    if(assignee==null)
      {
        return "Choose Assignee";
      }
    if (FirebaseAuth.instance.currentUser.uid == assignee?.id) {
      return "ME";
    } else {
      return assignee?.name;
    }
  }
}