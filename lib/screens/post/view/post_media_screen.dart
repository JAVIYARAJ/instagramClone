import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/main_scrren.dart';
import 'package:instagram_clone/screens/post/bloc/post_bloc.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
    _tagController.dispose();
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      context.read<PostBloc>().add(PostGetLocalMedia());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            },
            child: const Icon(
              Icons.close,
              size: 30,
            )),
        title: const Text('New Post'),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                'Next',
                style: GoogleFonts.roboto().copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.blueAccent.withOpacity(0.6)),
              ))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 0)),
                  const Divider(),
                  BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      if (state.postDataHolder.selectedImages.isNotEmpty) {
                        return Expanded(
                          child: SizedBox(
                            child: Image(
                              fit: BoxFit.fill,
                              image: FileImage(
                                state.postDataHolder.selectedImages.last,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                return Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "Recent",
                                style: GoogleFonts.roboto().copyWith(
                                    color: Colors.black, fontSize: 22),
                              ),
                              const Expanded(child: SizedBox()),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<PostBloc>()
                                      .add(PostMediaSelectType());
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, strokeAlign: 4),
                                      borderRadius: BorderRadius.circular(50),
                                      color: state.postDataHolder.isMultiSelect
                                          ? Colors.blueAccent
                                          : Colors.transparent),
                                  child: Center(
                                    child: Icon(
                                      Icons.select_all_sharp,
                                      color: state.postDataHolder.isMultiSelect
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  /*Uint8List? image =
                                      await pickImage(ImageSource.camera);
                                  if(image!=null && context.mounted){
                                    context.read<PostBloc>().add(PostPickMedia([
                                      image
                                    ]));
                                  }*/
                                },
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: GridView.count(
                            crossAxisSpacing: 4,
                            crossAxisCount: 3,
                            scrollDirection: Axis.vertical,
                            children: List.generate(
                                state.postDataHolder.localImages.length,
                                (index) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<PostBloc>().add(PostPickMedia(state.postDataHolder.localImages[index]));
                                },
                                onLongPress: (){
                                  context.read<PostBloc>().add(PostMediaSelectType(file:state.postDataHolder.localImages[index]));
                                },
                                child: SizedBox(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image(
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.33,
                                        image: FileImage(state
                                            .postDataHolder.localImages[index]),
                                      ),
                                      if (state
                                          .postDataHolder.isMultiSelect) ...[
                                        Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              height: 28,
                                              width: 28,
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      strokeAlign: 4),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: !state.postDataHolder.selectedImages.contains(state.postDataHolder.localImages[index])
                                                      ? Colors.grey
                                                          .withOpacity(0.3)
                                                      : Colors.blueAccent),
                                              child: Center(
                                                child: Text(!state.postDataHolder.selectedImages.contains(state.postDataHolder.localImages[index]) ? "":(state.postDataHolder.selectedImages.indexOf(state.postDataHolder.localImages[index])+1).toString(),
                                                  style: GoogleFonts.roboto()
                                                      .copyWith(fontSize: 14),
                                                ),
                                              ),
                                            ))
                                      ]
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
            /*BlocListener(listener:  (context, state) {
              if(state is PostLoaded && state.postDataHolder.localImages.isNotEmpty){
                showModal(context);
              }
            },)*/
          ],
        ),
      ),
    );
  }

}
