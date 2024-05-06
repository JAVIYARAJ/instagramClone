import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/common_widget.dart';
import 'package:instagram_clone/widgets/text_filed_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../utils/utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings?.arguments as Map<String, dynamic>?;
      if (args != null) {
        context
            .read<EditProfileBloc>()
            .add(EditProfileInitialEvent(args["data"] as UserInfo?));
      }
    });
    super.initState();
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
                  Uint8List? image = await pickImage(ImageSource.camera);
                  if (image != null && context.mounted) {
                    context
                        .read<EditProfileBloc>()
                        .add(EditProfileImageChangeEvent(image));
                  }
                },
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? image = await pickImage(ImageSource.gallery);
                  if (image != null && context.mounted) {
                    context
                        .read<EditProfileBloc>()
                        .add(EditProfileImageChangeEvent(image));
                  }
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
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileLoadingState) {
              context.loaderOverlay.show();
            } else if (state is EditProfileLoadedState) {
              context.loaderOverlay.hide();
            } else if (state is EditProfileErrorState) {
              showToast(state.error);
            }
          },
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          color: primaryColor,
                          size: 30,
                        ),
                      ),
                      const Text(
                        "Edit profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                      GestureDetector(
                          onTap: () async {},
                          child: Text(
                            "Save",
                            style: GoogleFonts.roboto().copyWith(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
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
                          if (state.editProfileDataHolder.userProfile == null) ...[
                            CommonImageWidget(
                                imageUrl: state
                                    .editProfileDataHolder.userInfo?.photoUrl,
                                radius: 50,
                                width: 100,
                                height: 100)
                          ] else ...[
                            SizedBox(
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
                                          image: MemoryImage(state
                                              .editProfileDataHolder
                                              .userProfile!))),
                                ),
                              ),
                            ),
                          ],
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
                        TextFormWidget(
                          controller: context.read<EditProfileBloc>().username,
                          onChanged: (value) {},
                          onSuffixTap: () {},
                          suffixIconVisible: false,
                          prefixIcon: Icons.person,
                          hintText: "Enter username",
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormWidget(
                          controller: context.read<EditProfileBloc>().bio,
                          onChanged: (value) {},
                          onSuffixTap: () {},
                          suffixIconVisible: false,
                          prefixIcon: Icons.closed_caption,
                          hintText: "Enter bio",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
