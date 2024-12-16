
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/group.dart';
import '../screen/group_chat_screen.dart';

class GroupUserCard extends StatefulWidget {
  final Group group;

  const GroupUserCard({super.key, required this.group});

  @override
  State<GroupUserCard> createState() => _GroupUserCardState();
}

class _GroupUserCardState extends State<GroupUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => GroupChatScreen(group: widget.group)));
          },
          child: ListTile(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            tileColor: Colors.white,
            style: ListTileStyle.drawer,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(widget.group.name),
            subtitle: Text(widget.group.lastMessage,
                style: const TextStyle(fontSize: 12), maxLines: 1),
            trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(10)),
            ),
          )),
    );
  }
}