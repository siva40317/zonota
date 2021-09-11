import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zonota/common/global.dart';
import 'package:zonota/models/task_model.dart';
import 'package:zonota/models/notes_model.dart';
import 'package:zonota/models/user_model.dart';

abstract class Repository {
  Future<bool> addTask(TaskModel taskModel);
  Future<bool> addNotes(NotesModel notesModel);
  Future<List<UserModel>> getContacts();
  Future<bool> updateProgress(String id,int progress,int status);
  Future<bool> shareNotes(List<UserModel> users,NotesModel notesModel);
}

class RepositoryImpl implements Repository {


  static const TASKS="tasks";
  static const NOTES="notes";
  static const USERS="users";


  Future<bool> registerUser(phone,name) async {

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var user =  FirebaseAuth.instance.currentUser;
    UserModel userModel = await fetchUserData();
    if(userModel==null)
    {
      await firestore.collection(USERS).doc(user?.uid).set({"id":user?.uid,"phone":"+91"+phone,"name":name,});
      var regUser = await fetchUserData();
      return regUser!=null;
    }
    return false;


  }


  Future<UserModel> fetchUserData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var user = FirebaseAuth.instance.currentUser;
    var snapshot = await firestore.collection(USERS).doc(user?.uid).get();
    if (snapshot.exists) {
      UserModel userModel = UserModel.fromJson(snapshot.data());
      return userModel;
    } else {
      return null;
    }
  }


  @override
  Future<bool> addTask(TaskModel taskModel) async {
    try {
      CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
      var ref = await tasks.add(taskModel.toJson());
      await ref.update({"id": ref.id});
      return ref != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> addNotes(NotesModel notesModel) async {
    try {

      CollectionReference tasks =  FirebaseFirestore.instance.collection('notes');
      var ref = await tasks.add(notesModel.toJson());
      await ref.update({"id": ref.id});
      return ref != null;
    } catch (e) {
      return false;
    }
  }


  @override
  Future<bool> updateProgress(String id,int progress,int status) async {
    try {

      var tasks =  FirebaseFirestore.instance.collection('tasks').doc(id);
      await tasks.update({
        'status':status,
        'progress':progress
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<UserModel>> getContacts() async {
    try {
      QuerySnapshot snapshot =await FirebaseFirestore.instance.collection('users').get();
      List<UserModel> users =  snapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
      List<String> phones =  users.map((e) => e.phone).toList();



      Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
      var myContacts = contacts.where((element) => element.phones.isNotEmpty).toList() ?? [];
      print(FirebaseAuth.instance.currentUser.phoneNumber);
      print(contacts.first.phones.first.value.replaceAll(' ', ''));
      print(phones);

      return myContacts.where((element) => (phones.contains(element?.phones?.first?.value?.replaceAll(' ', ''))
      || phones.contains(getNonCountryCodeNumber(element?.phones?.first?.value?.replaceAll(' ', ''))))
          && element?.phones?.first?.value?.replaceAll(' ', '') != FirebaseAuth.instance.currentUser.phoneNumber.replaceAll(' ', '')
          && getNonCountryCodeNumber(element?.phones?.first?.value?.replaceAll(' ', '')) != FirebaseAuth.instance.currentUser.phoneNumber.replaceAll(' ', ''))
          .map((e) => UserModel(id:users.where((element) => element?.phone == e?.phones?.first?.value?.replaceAll(' ', '') || element?.phone == getNonCountryCodeNumber(e?.phones?.first?.value?.replaceAll(' ', ''))
          ).toList()?.first?.id,name:e.displayName,phone:e.phones?.first?.value)).toList();

    } catch (e) {
      return [];
    }
  }


  @override
  Future<bool> shareNotes(List<UserModel> users,NotesModel notesModel) async {
    users.forEach((user)  {
       FirebaseFirestore.instance
          .collection('notes')
          .doc(notesModel.id).set({'receivers':users.map((e) => e.id).toList()},SetOptions(merge:true));
    });

    return true;
  }


  getNonCountryCodeNumber(String phone)
  {

    if(phone.length<10)
      return phone;

    if(phone.length==10)
      return '+91'+phone;

    return phone.substring(phone.length-10,phone.length);


  }


}
