// ignore_for_file: dead_code

import 'package:chatapp/Pages/homePage.dart';
import 'package:chatapp/helper/Shared_prefrence.dart';
import 'package:chatapp/serivice/authService.dart';
import 'package:chatapp/serivice/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../signup.dart';
import 'package:chatapp/helper/widgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  bool _obsecureText = true;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Groupie",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("login to see what they are talking"),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                      width: 400,
                      height: 250,
                      child: Image.asset(
                        "assets/login.png",
                        fit: BoxFit.cover,
                      )),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: inputDeco.copyWith(
                              hintText: "Enter your email",
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.red,
                              ),
                              labelText: "Email",
                            ),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                                print(email);
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                    print(password);
                                  });
                                },
                                obscureText: _obsecureText,
                                decoration: inputDeco.copyWith(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obsecureText = !_obsecureText;
                                        });
                                      },
                                      icon: Icon(
                                        _obsecureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      )),
                                  hintText: "Password",
                                  prefixIcon: const Icon(
                                    Icons.password,
                                    color: Colors.red,
                                  ),
                                  labelText: "Password",
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                width: double.infinity,
                                child: TextButton(
                                    onPressed: () => {loginUser()},
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        "Sign in ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22),
                                      ),
                                    ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("don't have account"),
                                TextButton(
                                    onPressed: () => {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewScreen()))
                                        },
                                    child: const Text(
                                      "register here",
                                      style: TextStyle(color: Colors.blue),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  loginUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isLoading = true;
    });
    authService.login(email, password).then(
      (value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseSerivce(uid: FirebaseAuth.instance.currentUser!.uid)
                  .getuser(email);
          await HeperFunction.saveUserLoggedIn(true);
          await HeperFunction.saveUserName(snapshot.docs[0]["fullname"]);
          await HeperFunction.saveUserEmail(email);
          nextReplaceScreen(context, HomePage());
        } else {
          customToastmessage(context, value);
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }
}
