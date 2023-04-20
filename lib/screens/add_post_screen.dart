import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/main_scrren.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/error_type.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  TextEditingController _captionContoller = TextEditingController();
  bool isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
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

  void postImage(String uid, String username, String profileImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
          _captionContoller.text.trim(), _file!, uid, username, profileImage);

      if (res == '601') {
        setState(() {
          isLoading = false;
          _file=null;
        });
        // ignore: use_build_context_synchronously
        showSnackBar(errorType[res]!, context, Colors.green);
        _captionContoller.text="";
      } else {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackBar(errorType[res]!, context, Colors.red);
      }
    } catch (error) {
      showSnackBar(error.toString(), context, Colors.red);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _captionContoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () {
                _selectImage(context);
              },
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading:GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MainScreen()));
                  },
                  child: const Icon(Icons.arrow_back)),
              title: const Text('Post to'),
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.uid!, user.username!, user.photoUrl!),
                    child: const Text(
                      'Post',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: Center(
              child: Column(
                children: [
                  isLoading == true
                      ? const LinearProgressIndicator(
                          backgroundColor: Colors.green,
                          minHeight: 5,
                        )
                      : const Padding(padding: EdgeInsets.only(top: 0)),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.photoUrl!),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          controller: _captionContoller,
                          maxLines: 8,
                          decoration: const InputDecoration(
                              hintText: 'Write a caption..',
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: AspectRatio(
                          aspectRatio: 400 / 450,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter,
                                    image: MemoryImage(_file!))),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
