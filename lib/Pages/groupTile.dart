import 'package:chatapp/Pages/chatpage.dart';
import 'package:chatapp/helper/widgets.dart';
import 'package:flutter/material.dart';

class groupTile extends StatefulWidget {
  String userName = "";
  String groupId = "";
  String groupName = "";
  groupTile(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.groupName});
//  groupTile({Key? key,required this.userName, required this.groupId, required this.groupName}):super(key: key);

  @override
  State<groupTile> createState() => _groupTileState();
}

class _groupTileState extends State<groupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            chatpage(
              userName: widget.userName,
              groupId: widget.groupId,
              groupName: widget.groupName,
            ));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
            radius: 30,
          ),
          title: Text(
            widget.groupName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
