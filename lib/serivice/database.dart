import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseSerivce {
  final String? uid;
  DatabaseSerivce({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  //updating the userData
  Future updateUserData(String fullname, String email) async {
    return await userCollection.doc(uid).set({
      "fullname": fullname,
      "email": email,
      "groups": [],
      "profilepic": "",
      "uid": uid,
    });
  }

  //getting the data
  Future getuser(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get user group
  getuseGroup() async {
    return userCollection.doc(uid).snapshots();
  }

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentRef = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentSender": "",
    });
    await groupDocumentRef.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentRef.id,
    });

    DocumentReference userDocumentRef = userCollection.doc(uid);
    return await userDocumentRef.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentRef.id}_$groupName"])
    });
  }

  getchat(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["admin"];
  }

  getGroupMember(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  searchBygroupName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocuRef = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocuRef.get();

    List<dynamic> groups = documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future togglejoinChat(
      String groupId, String userName, String groupName) async {
    DocumentReference userDocumentRefr = userCollection.doc(uid);
    DocumentReference groupDocumentRef = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentRefr.get();

    List<dynamic> groups = documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentRefr.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentRef.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentRefr.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentRef.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  sendMessage(String groupId, Map<String, dynamic> chatmessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatmessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatmessageData["message"],
      "recentSender": chatmessageData["sender"],
      "recentMessageTime": chatmessageData["time"].toString()
    });
  }
}
