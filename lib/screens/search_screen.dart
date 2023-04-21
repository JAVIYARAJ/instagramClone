import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController? _searchController;

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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) {},
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
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("posts").snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  var data = snapshot.data?.docs;

                  var posts = data
                      ?.map((e) =>
                          e.data().map((key, value) => MapEntry(key, value)))
                      .toList();
                  return GridView.builder(
                    itemCount: posts!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:2,
                      ), itemBuilder: (context,index){
                          return Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(posts[index]["postUrl"]),
                          );
                  });
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
