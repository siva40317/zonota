
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zonota/models/TaskModel.dart';
import 'package:zonota/models/user_model.dart';


var wallet_balance = 0;

List<TaskModel>  myTasks;

Iterable<Contact> myContacts;


getNameByContactNumber(phone)
 {
  if(myContacts==null || myContacts.isEmpty)
    return phone;

  var list =  myContacts.where((element) =>  element?.phones?.first?.value?.replaceAll(' ', '') ==  phone.replaceAll(' ', '')
       || getNonCountryCodeNumber(element?.phones?.first?.value?.replaceAll(' ', '')) == FirebaseAuth.instance.currentUser.phoneNumber.replaceAll(' ', ''))
      .map((e) => e.displayName)?.toList();
  return list.isNotEmpty?list.first:phone;

}

getNonCountryCodeNumber(String phone)
{

  if(phone.length<10)
    return phone;

  if(phone.length==10)
    return '+91'+phone;

  return phone.substring(phone.length-10,phone.length);


}