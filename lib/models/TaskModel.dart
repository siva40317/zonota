import 'dart:convert';

class TaskModel{
  String id;
  String title;
  String content;
  String creatorId;
  String creatorPhone;
  String assigneeId;
  String assigneePhone;
  int status;
  int progress;
  int createdTime;
  int modifiedTime;


  TaskModel({
    this.id,
    this.title,
    this.content,
    this.creatorId,
    this.creatorPhone,
    this.assigneeId,
    this.assigneePhone,
    this.status,
    this.progress,
    this.createdTime,
    this.modifiedTime,
  });


  factory TaskModel.fromJson(Map<String,dynamic> parsedJson){
    return TaskModel(
      id : parsedJson['id'],
      title : parsedJson['title'],
      content : parsedJson['content'],
      creatorId : parsedJson['creatorId'],
      creatorPhone : parsedJson['creatorPhone'],
      assigneeId : parsedJson['assigneeId'],
      assigneePhone : parsedJson['assigneePhone'],
      status : parsedJson['status'],
      progress : parsedJson['progress'],
      createdTime : parsedJson['createdTime'],
      modifiedTime : parsedJson['modifiedTime'],
    );
  }

  static List<TaskModel> listFromJson(List<dynamic> list) {
    List<TaskModel> rows = list.map((i) => TaskModel.fromJson(i)).toList();
    return rows;
  }

  static List<TaskModel> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TaskModel>((json) => TaskModel.fromJson(json)).toList();
  }

  Map<String,dynamic> toJson()=>{
    'id' : id,
    'title' : title,
    'content' : content,
    'creatorId' : creatorId,
    'creatorPhone' : creatorPhone,
    'assigneeId' : assigneeId,
    'assigneePhone' : assigneePhone,
    'status' : status,
    'progress' : progress,
    'createdTime' : createdTime,
    'modifiedTime' : modifiedTime,
  };

}