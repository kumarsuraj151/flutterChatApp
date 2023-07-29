import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const inputDeco = InputDecoration(
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    errorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black)));

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextReplaceScreen(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void customToastmessage(BuildContext context, String msg) {
  FToast fToast = FToast();
  fToast.init(context);
  fToast.showToast(
      child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.blueGrey,
    ),
    child: Text(
      msg,
      style: TextStyle(color: Colors.white),
    ),
  ));
}
