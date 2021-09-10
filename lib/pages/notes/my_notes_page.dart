import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/pages/notes/notes_list_item.dart';

class MyNotesPage extends StatefulWidget {
  MyNotesPage({Key key}) : super(key: key);

  @override
  _MyNotesPageState createState() => _MyNotesPageState();
}

class _MyNotesPageState extends State<MyNotesPage> {
  @override
  Widget build(BuildContext context) {
    return myNotesList();
  }

  Widget myNotesList()
  {
    return Container(

        child:
        StreamBuilder(
            stream: FirebaseFirestore.instance.collection('notes').orderBy('modifiedTime',descending:true).where('creatorId',isEqualTo:FirebaseAuth.instance.currentUser.uid).snapshots(),
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
                  return NotesListItem(data:NotesModel.fromJson( snapshot.data.docs[index].data()));
                },
              );
            }));

  }

}