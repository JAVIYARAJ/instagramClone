import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController? _searchController;
  bool isPostVisible = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .height,
            child: Column(
              children: [
                TextFormField(
                  onFieldSubmitted: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        isPostVisible = true;
                      });
                    }
                    setState(() {
                      isPostVisible = false;
                    });
                  },
                  controller: _searchController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: 20),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 25,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                isPostVisible == true
                    ? Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data?.docs;

                        var posts = data
                            ?.map((e) =>
                            e
                                .data()
                                .map((key, value) => MapEntry(key, value)))
                            .toList();
                        return StaggeredGridView.countBuilder(
                            crossAxisCount: 3,
                            itemCount: posts?.length,
                            itemBuilder: (context, index) {
                              return Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(posts![index]["postUrl"]),
                              );
                            },
                            staggeredTileBuilder: (index) =>
                                StaggeredTile.count(
                                    (index % 5 == 0) ? 2 : 1,
                                    (index % 5 == 0) ? 2 : 1));
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                )
                    : Expanded(
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .where("username",
                          isGreaterThanOrEqualTo: _searchController?.text)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileScreen(uid: snapshot.data
                                              ?.docs[index]["uid"])));
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        snapshot.data?.docs[index]["photoUrl"]),
                                  ),
                                  title: Text(
                                    snapshot.data?.docs[index]["username"],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data?.docs.length,
                          );
                        }
                        else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )),
              ],
            ),
          )),
    );
  }
}
