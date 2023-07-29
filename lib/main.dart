import 'package:chatapp/Pages/homePage.dart';
import 'package:chatapp/Pages/login.dart';
import 'package:chatapp/helper/Shared_prefrence.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isloggedStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HeperFunction.getUserLogginStatus().then((value) {
      if (value != null) {
        setState(() {
          _isloggedStatus = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isloggedStatus ? HomePage() : Login(),
    );
  }
}
