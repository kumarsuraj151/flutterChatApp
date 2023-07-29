import 'package:chatapp/Pages/homePage.dart';
import 'package:chatapp/helper/widgets.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  String username;
  String email;
  MyProfile({super.key, required this.email, required this.username});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
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
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Icon(
                      Icons.account_circle,
                      size: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.username,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {
                nextReplaceScreen(context, HomePage());
              },
              title: const Text(
                "Groups",
                style: TextStyle(),
              ),
              leading: const Icon(
                Icons.group,
              ),
            ),
            ListTile(
              onTap: () => {},
              selected: true,
              selectedColor: Colors.red,
              title: const Text(
                "Profile",
                style: TextStyle(),
              ),
              leading: const Icon(
                Icons.account_circle,
              ),
            ),
            ListTile(
              onTap: () {},
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
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Icon(
                Icons.account_circle,
                size: 200,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Full Name",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(widget.username,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Text(widget.email,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
