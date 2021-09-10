
import 'package:flutter/material.dart';
import 'package:zonota/common/common_constant.dart';
import 'package:zonota/common/global.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/pages/choose_contacts_page.dart';
import 'package:zonota/repositories/repository.dart';

import 'notes_detail_page.dart';

class ReceivedNotesListItem extends StatefulWidget {
  @required final NotesModel data;
  ReceivedNotesListItem({Key key, this.data}) : super(key: key);

  @override
  _ReceivedNotesListItemState createState() => _ReceivedNotesListItemState();
}

class _ReceivedNotesListItemState extends State<ReceivedNotesListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(

        onTap:()
    {
      Navigator.push(context, new MaterialPageRoute(builder:(context)=> NotesDetailPage(notesModel:widget.data,)));
    },
    child:Container(
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
          Container(child:Row(
            children: [
             Expanded(child: Text(widget?.data?.title??"",style:TextStyle(color:Colors.grey,fontWeight:FontWeight.w900,
                  fontSize:SizeConfig.h6),)),
              InkWell(
                  onTap:() async
                  {
                   var contacts = await  Navigator.push(context, new MaterialPageRoute(builder:(context)=> ChooseContactsPage()));
                   if(contacts!=null && contacts.isNotEmpty)
                     {
                       await RepositoryImpl().shareNotes(contacts, widget.data);
                     }
                  },
                  child:Icon(Icons.share))
            ],
          )),
          SizedBox(height:SizeConfig.height(2),),
          Container(child:Text(widget?.data?.content??"",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
              fontSize:SizeConfig.t1),)),
          Divider(),
          Row(children: [
            Icon(Icons.account_circle_rounded),
            SizedBox(width:SizeConfig.fitwidth(2),),
            Expanded(child:Text(getNameByContactNumber(widget?.data?.creatorPhone)??"",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
                fontSize:SizeConfig.t1),)),

            SizedBox(width:SizeConfig.fitwidth(5),),
            Container(child:Text(CommonConstant.timeAgoSinceDate(widget?.data?.modifiedTime)??"",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w300,
                fontSize:SizeConfig.s1),))
          ],)



        ],
      ),
    ));
  }
}