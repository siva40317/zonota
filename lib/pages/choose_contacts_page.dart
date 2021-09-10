import 'dart:collection';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/models/user_model.dart';
import 'package:zonota/repositories/repository.dart';

class ChooseContactsPage extends StatefulWidget {
  final bool singleChoice;
  ChooseContactsPage({Key key, this.singleChoice}) : super(key: key);

  @override
  _ChooseContactsPageState createState() => _ChooseContactsPageState();
}

class _ChooseContactsPageState extends State<ChooseContactsPage> {


  bool permissionGranted = false;

  List<UserModel> selectedUsers = [];

  List<UserModel> contacts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _askPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:new FloatingActionButton(
        backgroundColor:AppColors.colorFromHex(AppColors.primary),
          onPressed:()
        {
           Navigator.pop(context,selectedUsers);
        },
        child:Icon(Icons.done),
      ),
      appBar:new AppBar(
        elevation:0,
        title:Text("Choose Contacts"),
      ),
      body:Container(
        color:Colors.white,
        height:SizeConfig.height(100),
        child:permissionGranted?myContactList():requestPermissionScreen()
      ),
    );
  }

  requestPermissionScreen()
  {
    return Container(
      alignment: Alignment.center,
      height: SizeConfig.height(100),
      child:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          SizedBox(height:SizeConfig.fitheight(5),),
          Text("Allow Permission to access your Contacts"),
          SizedBox(height:SizeConfig.fitheight(10),),
          Icon(Icons.contacts,size:SizeConfig.size(30),color:AppColors.colorFromHex(AppColors.grey900),),
          SizedBox(height:SizeConfig.fitheight(10),),
          getGrantButton()

        ],
      ),
    );
  }


  getGrantButton()
  {
    return Container(
        width:SizeConfig.width(90),
        height:SizeConfig.height(8),

        child:ElevatedButton(
          style:ElevatedButton.styleFrom(
              elevation:SizeConfig.size(2),
              primary:AppColors.colorFromHex(AppColors.primary)
          ),
          onPressed:()async
          {
            _askPermissions();

          },
          child: Text("Grant Permission",style:TextStyle(color:Colors.white),),
        ));
  }

    _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      permissionGranted=true;
      setState(() {

      });
      contacts = await RepositoryImpl().getContacts();
      print(contacts.map((e) => e.id));
      setState(() {
        
      });
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
       Fluttertoast.showToast(msg:'Access to contact data denied');
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      Fluttertoast.showToast(msg:'Contact data not available on device');
    }
  }


  Widget myContactList()
  {
    return Container(
        child:
        ListView.builder(

                itemCount:contacts.length,
                itemBuilder: (context,index){
                  return Container(
                      child:ListTile(
                    onTap:()
                    {
                      if(widget.singleChoice!=null && widget.singleChoice)
                        {
                          setState(() {
                            selectedUsers.clear();
                          });
                        }
                      selectedUsers.contains(contacts[index])?selectedUsers.remove(contacts[index]):selectedUsers.add(contacts[index]);
                      setState(() {

                      });
                    },
                    title:Text(contacts[index].name.toString()),
                    subtitle:Text(contacts[index].phone.toString()),
                    trailing: selectedUsers.contains(contacts[index])? Icon(Icons.cloud_done_sharp,color: Colors.green,):Icon(Icons.add,color: Colors.green,),
                  ));
                },
              ));

  }

}