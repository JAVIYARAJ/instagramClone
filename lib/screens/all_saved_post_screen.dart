import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';

class AllSavedPostScreen extends StatefulWidget {
  const AllSavedPostScreen({Key? key}) : super(key: key);

  @override
  State<AllSavedPostScreen> createState() => _AllSavedPostScreenState();
}

class _AllSavedPostScreenState extends State<AllSavedPostScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getAllSavedPost() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "All Posts",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: FutureBuilder(
          future: FireStoreMethods()
              .getSavedAllPost(FirebaseAuth.instance.currentUser!.uid),
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            var data = snapshot.data;

            if(snapshot.hasData){
              return GridView.builder(
                  itemCount: data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return Image(
                      image: NetworkImage(data[index]["postUrl"]),
                      fit: BoxFit.cover,
                    );
                  });
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

          },
        ),
      ),
    );
  }
}
