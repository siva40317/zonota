import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zonota/common/image_asset.dart';
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
                 return getNoDataView();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return getLoadingView();
              }

              return ListView.builder(
                itemCount:snapshot?.data?.docs?.length??0,
                itemBuilder: (context,index){
                  return NotesListItem(data:NotesModel.fromJson( snapshot.data.docs[index].data()));
                },
              );
            }));

  }

  getNoDataView()
  {
    return Container(
        alignment:Alignment.center,
        color:Colors.white,
        height:SizeConfig.height(100),
        child:Container(
          child:Column(
            children: [
              Image.asset(ImageAsset.noNotes,height:SizeConfig.height(30),),
              SizedBox(height:SizeConfig.height(5),),
              Text('No Notes Created , Click + to Create A New Note')
            ],
          ),
        ));
  }

  getLoadingView()
  {
    return Container(
      alignment:Alignment.center,
      height:SizeConfig.height(100),
      child:CircularProgressIndicator(

      ),
    );
  }


}