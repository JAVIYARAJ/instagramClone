import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  Uint8List? _file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Edit Profile'),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? image = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = image;
                  });
                },
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? image = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = image;
                  });
                },
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    _nameController.text = user.username!;
    _bioController.text = user.bio!;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 35,
                      )),
                  const Text(
                    "Edit profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: () async {
                        //save data
                        bool isUpdateImage = _file == null ? false : true;
                        String res = await FireStoreMethods().updateProfile(
                            user.uid!,
                            _nameController.text,
                            _bioController.text,
                            _file!,
                            isUpdateImage);
                        await UserProvider().refreshUser();
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.done,
                        size: 40,
                        color: Colors.blueAccent,
                      )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      _file == null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(user.photoUrl!),
                            )
                          : SizedBox(
                              width: 100,
                              height: 100,
                              child: AspectRatio(
                                aspectRatio: 400 / 450,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          alignment: FractionalOffset.topCenter,
                                          image: MemoryImage(_file!))),
                                ),
                              ),
                            ),
                      TextButton(
                          onPressed: () {
                            _selectImage(context);
                          },
                          child: const Text(
                            "Edit picture",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Bio",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _bioController,
                      decoration: const InputDecoration(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
