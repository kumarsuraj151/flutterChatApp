import 'package:chatapp/Pages/homePage.dart';
import 'package:chatapp/helper/widgets.dart';
import 'package:chatapp/serivice/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class groupInfo extends StatefulWidget {
  String admin = "";
  String userName = "";
  String groupId = "";
  String groupName = "";
  groupInfo(
      {super.key,
      required this.admin,
      required this.userName,
      required this.groupId,
      required this.groupName});

  @override
  State<groupInfo> createState() => _groupInfoState();
}

class _groupInfoState extends State<groupInfo> {
  Stream? members;
  @override
  void initState() {
    // TODO: implement initState
    getGroupMember();
    super.initState();
  }

  getGroupMember() {
    DatabaseSerivce(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMember(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  getadminName(String str) {
    return str.substring(str.indexOf("_") + 1);
  }

  getuserId(String str) {
    return str.substring(0, str.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat Info"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Exit"),
                      content:
                          const Text("Are you sure want to exit the group"),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                        IconButton(
                            onPressed: () async {
                               DatabaseSerivce(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .togglejoinChat(
                                      widget.groupId,
                                      getadminName(widget.admin),
                                      widget.groupName)
                                  .whenComplete(() {
                                nextReplaceScreen(context, const HomePage());
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            )),
                      ],
                    );
                  });
              // authService.logout();
              // nextReplaceScreen(context, Login());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red[100]),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: TextStyle(fontSize: 27),
                    ),
                    radius: 25,
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Admin: ${getadminName(widget.admin)}",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  )
                ],
              ),
            ),
            membersList()
          ],
        ),
      ),
    );
  }

  membersList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null) {
              if (snapshot.data["members"] != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              getadminName(snapshot.data['members'][index])
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(fontSize: 27),
                            ),
                            radius: 25,
                            backgroundColor: Colors.red,
                          ),
                          title: Text(
                            getadminName(snapshot.data['members'][index]),
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text(getuserId(snapshot.data['members'][index])),
                        ),
                      );
                    });
              } else {
                return Text("No members");
              }
            } else {
              return Text("No members");
            }
          } else {
            return Text("No members");
          }
        });
  }
}
