import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

Future<Uint8List?> pickImage(ImageSource imageSource) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: imageSource);
  if (file != null) {
    return await file.readAsBytes();
  }
  return null;
}

Future<List<XFile>?> pickPostImages() async {
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? file = await imagePicker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 70,
      requestFullMetadata: true);

  return file;
}

showSnackBar(String content, BuildContext context, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      style: const TextStyle(fontSize: 15, color: Colors.white),
    ),
    backgroundColor: color,
  ));
}

String convertDate(Timestamp date) {
  var res = DateFormat.yMMMd().format(date.toDate());
  return res;
}

void showToast(String msg) {
  Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT);
}

String dateToString(DateTime dateTime) {
  return DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
}

String formatInstagramPostDate(String dateStr) {
  // Parse the input date string
  final format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  final postDate = format.parse(dateStr);
  final now = DateTime.now();

  // Calculate the time difference
  final duration = now.difference(postDate);
  if (duration.inSeconds < 10) {
    return "just now";
  }else if (duration.inSeconds < 60) {
    return "${duration.inSeconds} seconds ago";
  } else if (duration.inMinutes < 60) {
    return "${duration.inMinutes} minutes ago";
  } else if (duration.inHours < 24) {
    return "${duration.inHours} hours ago";
  } else if (duration.inDays < 30) {
    return "${duration.inDays} days ago";
  } else if (duration.inDays < 365) {
    final months = (duration.inDays / 30).floor();
    return months == 1 ? "1 month ago" : "$months months ago";
  } else {
    final years = (duration.inDays / 365).floor();
    return years == 1 ? "1 year ago" : "$years years ago";
  }
}