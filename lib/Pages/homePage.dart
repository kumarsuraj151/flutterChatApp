import 'package:chatapp/Pages/groupTile.dart';
import 'package:chatapp/Pages/login.dart';
import 'package:chatapp/Pages/search.dart';
import 'package:chatapp/helper/Shared_prefrence.dart';
import 'package:chatapp/helper/widgets.dart';
import 'package:chatapp/profile.dart';
import 'package:chatapp/serivice/authService.dart';
import 'package:chatapp/serivice/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String username = "";
  String email = "";
  Stream? groups;
  String groupName = "";
  @override
  void initState() {
    super.initState();
    getuserData();
  }

  getuserData() async {
    await HeperFunction.getUsername().then((value) {
      setState(() {
        username = value!;
      });
    });

    await HeperFunction.getUseremail().then((value) {
      setState(() {
        email = value!;
      });
    });

    await DatabaseSerivce(uid: FirebaseAuth.instance.currentUser!.uid)
        .getuseGroup()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  String getid(String str) {
    return str.substring(0, str.indexOf("_"));
  }

  String getgroupName(String str) {
    return str.substring(str.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Group"),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, searchPage());
              },
              icon: const Icon(Icons.search))
        ],
        backgroundColor: Colors.red,
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Icon(
                      Icons.account_circle,
                      size: 150,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    username,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {},
              selected: true,
              selectedColor: Colors.red,
              title: const Text(
                "Groups",
                style: TextStyle(),
              ),
              leading: const Icon(
                Icons.group,
              ),
            ),
            ListTile(
              onTap: () {
                nextScreen(
                    context,
                    MyProfile(
                      username: username,
                      email: email,
                    ));
              },
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(
                Icons.account_circle,
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("logout"),
                        content: const Text("Are you sure want to logout"),
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
                              onPressed: () {
                                authService.logout();
                                nextReplaceScreen(context, Login());
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
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: grouplist(),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Create a Group"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (val) {
                    setState(() {
                      groupName = val;
                    });
                  },
                  decoration: inputDeco,
                )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    DatabaseSerivce(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(username,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {});
                    Navigator.of(context).pop();
                    customToastmessage(context, "sucessfully created");
                  },
                  child: Text("Create")),
            ],
          );
        });
  }

  grouplist() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null &&
                snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseInd = snapshot.data["groups"].length - index - 1;
                    return groupTile(
                        userName: snapshot.data["fullname"],
                        groupId: getid(snapshot.data["groups"][reverseInd]),
                        groupName:
                            getgroupName(snapshot.data["groups"][reverseInd]));
                  });
            } else {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      popUpDialog(context);
                    },
                    child: Icon(
                      Icons.add_circle,
                      size: 75,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "You've not join any chat, Click on the icon to join chat.Also search any group from search icon on top",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ));
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }
        });
  }
}
