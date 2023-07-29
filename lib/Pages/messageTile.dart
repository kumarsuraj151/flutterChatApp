import 'package:flutter/material.dart';

class messageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sendByMe;
  messageTile(
      {super.key,
      required this.message,
      required this.sender,
      required this.sendByMe});

  @override
  State<messageTile> createState() => _messageTileState();
}

class _messageTileState extends State<messageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.sendByMe
          ? EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .2,
              top: 10,
              bottom: 10,
              right: 15)
          : EdgeInsets.only(
              right: MediaQuery.of(context).size.width * .2,
              top: 10,
              bottom: 10,
              left: 15),
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Text(
                  widget.sender,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Text(
                  widget.message,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
