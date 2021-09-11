import 'package:flutter/material.dart';
import 'package:zonota/common/common_constant.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/pages/choose_contacts_page.dart';
import 'package:zonota/pages/notes/notes_detail_page.dart';
import 'package:zonota/repositories/repository.dart';

class NotesListItem extends StatefulWidget {
  @required
  final NotesModel data;

  NotesListItem({Key key, this.data}) : super(key: key);

  @override
  _NotesListItemState createState() => _NotesListItemState();
}

class _NotesListItemState extends State<NotesListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          navigate();
        },
        child: Container(
          padding: EdgeInsets.all(SizeConfig.width(5)),
          margin: EdgeInsets.all(SizeConfig.size(1)),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(SizeConfig.size(5))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.height(1),
              ),
              Container(
                  child: Row(
                children: [getTitleView(), getShareView()],
              )),
              SizedBox(
                height: SizeConfig.height(2),
              ),
              getContentView(),
              SizedBox(
                height: SizeConfig.height(1),
              ),
              Divider(),
              SizedBox(
                height: SizeConfig.height(1),
              ),
              getTimeView()
            ],
          ),
        ));
  }

  getTitleView() {
    return Expanded(
        child: Text(
      widget.data.title,
      style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w900,
          fontSize: SizeConfig.h6),
    ));
  }

  getShareView() {
    return InkWell(
        onTap: () async {
          var contacts = await Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => ChooseContactsPage()));
          if (contacts != null && contacts.isNotEmpty) {
            await RepositoryImpl().shareNotes(contacts, widget.data);
          }
        },
        child: Icon(Icons.share));
  }

  getContentView() {
    return Container(
        child: Text(
      widget.data.content,
      maxLines: 5,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontSize: SizeConfig.t1),
    ));
  }

  getTimeView() {
    return Container(
        child: Text(
      CommonConstant.timeAgoSinceDate(widget?.data?.modifiedTime ?? 0),
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontSize: SizeConfig.s1),
    ));
  }

  navigate() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => NotesDetailPage(
                  notesModel: widget.data,
                )));
  }
}
