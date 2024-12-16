
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/chat_user.dart';
import '../screen/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user: widget.user)));
          },
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            tileColor: Colors.white,
            style: ListTileStyle.drawer,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height*.3),
              child: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(widget.user.name),
            trailing: Container(width: 15,height: 15,decoration:BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(10)),),
          )),
    );
  }
}