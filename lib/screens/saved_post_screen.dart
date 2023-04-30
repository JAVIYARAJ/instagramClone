import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../resources/firestore_methods.dart';
import 'all_saved_post_screen.dart';

class SavePostScreen extends StatefulWidget {
  const SavePostScreen({Key? key}) : super(key: key);

  @override
  State<SavePostScreen> createState() => _SavePostScreenState();
}

class _SavePostScreenState extends State<SavePostScreen> {
  var boxShadow = [
    const BoxShadow(offset: Offset(-2, 2), color: Colors.white),
    const BoxShadow(offset: Offset(2, 0), color: Colors.white),
    const BoxShadow(
      offset: Offset(0, -2),
      color: Colors.white,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          title: const Text(
            "Saved",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllSavedPostScreen()));
                  },
                  child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.only(top: 18),
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          boxShadow: boxShadow,
                          borderRadius: BorderRadius.circular(20)),
                      child: FutureBuilder(
                        future: FireStoreMethods().getSavedAllPost(
                            FirebaseAuth.instance.currentUser!.uid),
                        builder: (context,
                            AsyncSnapshot<List<Map<String, dynamic>>>
                                snapshot) {
                          var data = snapshot.data;

                          if (snapshot.hasData) {
                            return GridView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                itemCount: (data!.length > 4) ? 4 : data.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.50,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.50,
                                        image: NetworkImage(
                                            data[index]["postUrl"]),
                                      ));
                                });
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "All Post",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.only(top: 18),
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        boxShadow: boxShadow,
                        borderRadius: BorderRadius.circular(20)),
                    child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          // return SvgPicture.asset("assets/ic_saved_music_icon.svg");
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                  fit: BoxFit.cover,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  image: const NetworkImage(
                                      "https://m.media-amazon.com/images/I/91RUARIF3cL._SY679_.jpg")));
                        })),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.audiotrack,
                      size: 25,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Audio",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
