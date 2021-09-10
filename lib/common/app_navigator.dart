import 'package:flutter/cupertino.dart';

class AppNavigator {
  static Future<dynamic> push(
    context,
    Widget widget,
  ) async {
    return await Navigator.push(
      context,
      new PageRouteBuilder(
        pageBuilder: (c, a1, a2) => widget,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  static Future<dynamic> replace(context, Widget widget) async {
    return await Navigator.pushReplacement(
      context,
      new PageRouteBuilder(
        pageBuilder: (c, a1, a2) => widget,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }
}
