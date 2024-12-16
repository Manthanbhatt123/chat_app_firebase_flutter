import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sarthak/models/chat_user.dart';

import 'package:sarthak/models/message.dart';

import 'package:sarthak/models/group_messages.dart';

class APIs {
  //For User authentication
  static FirebaseAuth auth = FirebaseAuth.instance;


  static User get myUser => auth.currentUser!;

  static late ChatUser me;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for checking user existence
  static Future<bool> userExist() async {
    return (await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get())
        .exists;
  }

  static Future<void> selfInfo() async {
    await firestore
        .collection('users')
        .doc(myUser.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        createUser("user");
      }
    });
  }

  //for creating user
  static Future<void> createUser(String name) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        image: myUser.photoURL ?? '',
        name: myUser.displayName ?? name,
        about: "Hello Developer",
        createdAt: time,
        lastActive: time,
        isOnline: false,
        id: myUser.uid,
        pushToken: '',
        email: myUser.email.toString());

    // log(myUser.toString());
    return await firestore
        .collection('users')
        .doc(myUser.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: myUser.uid)
        .snapshots();
  }

  //for checking user existence
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update(
      {'name': me.name, 'about': me.about},
    );
  }

  /**
      -Chat Api are under this section
   */

  static String getConversationId(String id) =>
      myUser.uid.hashCode <= id.hashCode
          ? '${myUser.uid}_$id'
          : '${id}_${myUser.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatuser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        msg: msg,
        toId: chatuser.id,
        read: '',
        type: Type.Text,
        fromId: myUser.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationId(chatuser.id)}/messages/');

    await ref.doc(time).set(message.toJson());
  }

  /**--------------- group-chat----------------------------------*/
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroups() {
    return firestore.collection('groups').snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroupMessages(String groupId) {

    return firestore
        .collection('groups/$groupId/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendGroupMessage(String msg,String groupId) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Messages message = Messages(
        msg: msg, read_by: '', type: '', fromId: myUser.uid, sent: time);

    final ref = firestore.collection('groups/$groupId/messages/');

    await ref.doc(time).set(message.toJson());
    await firestore.collection('groups').doc(groupId).update({'last_message':msg});
  }

  static Future<void> createGroup(Map<String,Object> groupData)async{
    await FirebaseFirestore.instance.collection('groups').doc(groupData['group_id'].toString()).set(groupData).then((docRef) {

    }).catchError((error) {
      print("Failed to create group: $error");
    });
  }
}