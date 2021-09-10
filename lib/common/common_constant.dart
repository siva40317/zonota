import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonConstant {
  static const FONTS = {
    "OPEN_SANS_BOLD": "OpenSans-Bold",
    "OPEN_SANS_LIGHT": "SourceSansPro-Light",
    "OPEN_SANS_SEMI_BOLD": "OpenSans-SemiBold",
    "OPEN_SANS_REGULAR": "OpenSans-Regular"
  };



  static const ASSET_URL = {

  };

 static const IMAGE_CAR="https://cdn.mattaki.com/honda/news/content-pieces/4e4c15da-e551-4aaa-9b25-e3d1d069d289/image.png";

  static bool isTablet(MediaQueryData query) {
    var size = query.size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));

    /*
    print(
      'size: ${size.width}x${size.height}\n'
      'pixelRatio: ${query.devicePixelRatio}\n'
      'pixels: ${size.width * query.devicePixelRatio}x${size.height * query.devicePixelRatio}\n'
      'diagonal: $diagonal'
    );
    */

    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  static String timeAgoSinceDate(int time,
      {bool numericDates = true}) {
    //2020-03-18T15:02:48Z

    DateTime date = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(DateTime.fromMillisecondsSinceEpoch(time).toIso8601String());
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }


}