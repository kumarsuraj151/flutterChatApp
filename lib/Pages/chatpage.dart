import 'package:chatapp/Pages/groupInfo.dart';
import 'package:chatapp/Pages/messageTile.dart';
import 'package:chatapp/helper/widgets.dart';
import 'package:chatapp/serivice/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class chatpage extends StatefulWidget {
  String userName = "";
  String groupId = "";
  String groupName = "";
  chatpage(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.groupName});

  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  TextEditingController textEditingController = TextEditingController();
  Stream<QuerySnapshot>? chats;
  String admin = "";
  final ScrollController _scrollController=ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    getchatAdmin();
    super.initState();
  }

  getchatAdmin() {
    DatabaseSerivce().getchat(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });

    DatabaseSerivce().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.groupName),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: [
            GestureDetector(
              onTap: () {
                nextScreen(
                    context,
                    groupInfo(
                      admin: admin,
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      userName: widget.userName,
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(Icons.info),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.8,
              child: chatmessage(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          hintText: "Send Messages", border: InputBorder.none),
                    )),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(
                          Icons.send,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  chatmessage() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                controller: _scrollController,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return messageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sendByMe: widget.userName ==
                          snapshot.data.docs[index]['sender'],
                    );
                  })
              : Container(
                  child: Text("messages"),
                );
        });
  }

  sendMessage() {
    FocusManager.instance.primaryFocus?.unfocus();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.linear);
    if (textEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": textEditingController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch
      };

      DatabaseSerivce().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        textEditingController.clear();
      });
    }
  }
}
