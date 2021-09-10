import 'package:flutter/material.dart';

class AppColors{


 static String primary ="#203387";
 static String white ="#FFFFFF";
 static String accent="#2196F3";
 static String grey100= "#DAE2E6";
  static String grey900= "#AAAAAA";
 static String black = "#000000";
 static String silver = "#C0C0C0";
 static String whiteSmoke = "#F5F5F5";
 static String red = "#FF0000";
 static String green = "#37C545";


 static Color colorFromHex(String hexColor,{transparency}) {
  transparency!=null?hexColor=transparency.toString()+hexColor:hexColor=hexColor;
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
 }




}