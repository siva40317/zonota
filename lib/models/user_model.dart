import 'dart:convert';

class UserModel{
  String id;
  String name;
  String phone;


  UserModel({
    this.id,
    this.name,
    this.phone,
  });


  factory UserModel.fromJson(Map<String,dynamic> parsedJson){
    return UserModel(
      id : parsedJson['id'],
      name : parsedJson['name'],
      phone : parsedJson['phone'],
    );
  }

  static List<UserModel> listFromJson(List<dynamic> list) {
    List<UserModel> rows = list.map((i) => UserModel.fromJson(i)).toList();
    return rows;
  }

  static List<UserModel> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<UserModel>((json) => UserModel.fromJson(json)).toList();
  }

  Map<String,dynamic> toJson()=>{
    'id' : id,
    'name' : name,
    'phone' : phone,
  };

}