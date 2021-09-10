import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/TaskModel.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/pages/notes/notes_list_item.dart';
import 'package:zonota/pages/notes/received_notes_list_item.dart';
import 'package:zonota/pages/tasks/assigned_task_list_item.dart';

class AssignedTasksPage extends StatefulWidget {
  AssignedTasksPage({Key key}) : super(key: key);

  @override
  _AssignedTasksPageState createState() => _AssignedTasksPageState();
}

class _AssignedTasksPageState extends State<AssignedTasksPage> {
  @override
  Widget build(BuildContext context) {
    return myNotesList();
  }

  Widget myNotesList()
  {
    return Container(

        child:
        StreamBuilder(
            stream: FirebaseFirestore.instance.collection('tasks').where('assigneeId',isEqualTo:FirebaseAuth.instance.currentUser.uid).orderBy('modifiedTime',descending:true).snapshots(),
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
                  return AssignedTasksListItem(data:TaskModel.fromJson( snapshot.data.docs[index].data()));
                },
              );
            }));

  }

}