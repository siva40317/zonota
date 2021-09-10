import 'dart:convert';

class NotesModel{
  String id;
  String title;
  String content;
  String creatorId;
  String creatorPhone;
  int createdTime;
  int modifiedTime;


  NotesModel({
    this.id,
    this.title,
    this.content,
    this.creatorId,
    this.creatorPhone,
    this.createdTime,
    this.modifiedTime,
  });


  factory NotesModel.fromJson(Map<String,dynamic> parsedJson){
    return NotesModel(
      id : parsedJson['id'],
      title : parsedJson['title'],
      content : parsedJson['content'],
      creatorId : parsedJson['creatorId'],
      creatorPhone : parsedJson['creatorPhone'],
      createdTime : parsedJson['createdTime'],
      modifiedTime : parsedJson['modifiedTime'],
    );
  }

  static List<NotesModel> listFromJson(List<dynamic> list) {
    List<NotesModel> rows = list.map((i) => NotesModel.fromJson(i)).toList();
    return rows;
  }

  static List<NotesModel> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<NotesModel>((json) => NotesModel.fromJson(json)).toList();
  }

  Map<String,dynamic> toJson()=>{
    'id' : id,
    'title' : title,
    'content' : content,
    'creatorId' : creatorId,
    'creatorPhone' : creatorPhone,
    'createdTime' : createdTime,
    'modifiedTime' : modifiedTime,
  };

}