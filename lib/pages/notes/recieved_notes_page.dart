import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zonota/common/image_asset.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/pages/notes/notes_list_item.dart';
import 'package:zonota/pages/notes/received_notes_list_item.dart';

class ReceivedNotesPage extends StatefulWidget {
  ReceivedNotesPage({Key key}) : super(key: key);

  @override
  _ReceivedNotesPageState createState() => _ReceivedNotesPageState();
}

class _ReceivedNotesPageState extends State<ReceivedNotesPage> {
  @override
  Widget build(BuildContext context) {
    return myNotesList();
  }

  Widget myNotesList()
  {
    return Container(

        child:
        StreamBuilder(
            stream: FirebaseFirestore.instance.collection('notes').where('receivers',arrayContains:FirebaseAuth.instance.currentUser.uid).orderBy('modifiedTime',descending:true).snapshots(),
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
                  return ReceivedNotesListItem(data:NotesModel.fromJson( snapshot.data.docs[index].data()));
                },
              );
            }));

  }

  getNoDataView()
  {
    return Container(
      alignment:Alignment.center,
      height:SizeConfig.height(100),
      child:Column(
        children: [
          Image.asset(ImageAsset.noTasks,height:SizeConfig.height(30),),
          SizedBox(height:SizeConfig.height(5),),
          Text('No Notes Received , Click + to Create A New Note')
        ],
      ),
    );
  }

  getProgressView()
  {
    return Container(
      alignment:Alignment.center,
      height:SizeConfig.height(100),
      child:CircularProgressIndicator(

      ),
    );
  }

}