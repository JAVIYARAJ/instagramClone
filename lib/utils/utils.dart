import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?>pickImage(ImageSource imageSource) async{

  final ImagePicker imagePicker=ImagePicker();

  XFile? file=await imagePicker.pickImage(source: imageSource);
  if(file!=null){
    return await file.readAsBytes();
  }
}

showSnackBar(String content, BuildContext context,Color color) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(content,style: const TextStyle(
    fontSize: 20,color: Colors.white
  ),),backgroundColor: color,));
}
