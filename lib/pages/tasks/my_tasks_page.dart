import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zonota/common/image_asset.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/task_model.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/pages/notes/notes_list_item.dart';
import 'package:zonota/pages/tasks/my_tasks_list_item.dart';

class MyTasksPage extends StatefulWidget {
  MyTasksPage({Key key}) : super(key: key);

  @override
  _MyTasksPageState createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  @override
  Widget build(BuildContext context) {
    return myNotesList();
  }

  Widget myNotesList()
  {
    return Container(

        child:
        StreamBuilder(
            stream: FirebaseFirestore.instance.collection('tasks').orderBy('modifiedTime',descending:true).where('creatorId',isEqualTo:FirebaseAuth.instance.currentUser.uid).snapshots(),
            builder: (context,snapshot){
              if (snapshot.hasError || snapshot?.data?.docs?.length==0) {
                return getNoDataView();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                 return getProgressView();
              }


              return ListView.builder(
                itemCount:snapshot?.data?.docs?.length??0,
                itemBuilder: (context,index){
                  return MyTasksListItem(data:TaskModel.fromJson( snapshot.data.docs[index].data()));
                },
              );
            }));

  }

  getNoDataView()
  {
    return Container(
        alignment:Alignment.center,
        height:SizeConfig.height(100),
        child:Container(
          color:Colors.white,
          child:Column(
            children: [
              Image.asset(ImageAsset.noTasks,height:SizeConfig.height(30),),
              SizedBox(height:SizeConfig.height(5),),
              Text('No Tasks Created , Click + to Create A New Task')
            ],
          ),
        )
    );
  }

  getProgressView()
  {
    return  Container(
      alignment:Alignment.center,
      height:SizeConfig.height(100),
      child:CircularProgressIndicator(

      ),
    );
  }

}