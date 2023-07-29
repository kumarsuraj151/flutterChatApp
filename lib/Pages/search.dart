import 'package:chatapp/Pages/chatpage.dart';
import 'package:chatapp/Pages/groupTile.dart';
import 'package:chatapp/helper/Shared_prefrence.dart';
import 'package:chatapp/helper/widgets.dart';
import 'package:chatapp/serivice/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  TextEditingController textEditingController = TextEditingController();
  bool _isloading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool isjoined = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserNameAndId();
  }

  getCurrentUserNameAndId() async {
    await HeperFunction.getUsername().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seach"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            height: 75,
            padding: EdgeInsets.only(top: 5, left: 5, bottom: 5),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search for groups...",
                      hintStyle: TextStyle(color: Colors.white)),
                )),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        searchMethod();
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
              ],
            ),
          ),
          _isloading
              ? Center(
                  child: CircularProgressIndicator(color: Colors.red),
                )
              : searchlist()
        ],
      ),
    );
  }

  searchMethod() async {
    if (textEditingController.text.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      await DatabaseSerivce()
          .searchBygroupName(textEditingController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isloading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  searchlist() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return grouptile(
                  userName,
                  searchSnapshot!.docs[index]['groupId'],
                  searchSnapshot!.docs[index]['groupName'],
                  searchSnapshot!.docs[index]['admin']);
            })
        : Container(
            child: Text("from container"),
          );
  }

  joinOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseSerivce(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isjoined = value;
      });
    });
  }

  Widget grouptile(
      String userName, String groupId, String groupName, String admin) {
    joinOrNot(userName, groupId, groupName, admin);
    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
          leading: CircleAvatar(
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
            radius: 30,
          ),
          title: Text(
            groupName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text(
            "Admin: ${admin.substring(admin.indexOf("_") + 1)}",
            style: TextStyle(fontSize: 13),
          ),
          trailing: InkWell(
            onTap: () async {
              await DatabaseSerivce(uid: user!.uid)
                  .togglejoinChat(groupId, userName, groupName);
              if (isjoined) {
                setState(() {
                  isjoined = !isjoined;
                });
                customToastmessage(context, "user join the group succesfully");
                Future.delayed(Duration(seconds: 2), () {
                  nextScreen(
                      context,
                      chatpage(
                          userName: userName,
                          groupId: groupId,
                          groupName: groupName));
                });
              } else {
                setState(() {
                  isjoined = !isjoined;
                });
                customToastmessage(context, "user left the group succesfully");
              }
            },
            child:
                Container(child: isjoined ? Text("joined") : Text("join Now")),
          )),
    );
  }
}
