
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api.dart';
import '../main.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {

  @override
  Widget build(BuildContext context) {
    return APIs.myUser.uid == widget.message.fromId
        ? _sendMessage()
        : _receiveMessage();
  }

  Widget _receiveMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: mq.height * .03,
            child: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 15,
              ),
            )),
        Container(
          margin: EdgeInsets.only(right: mq.height * .02,top: 5),
          padding: EdgeInsets.symmetric(
              vertical: mq.height * .015, horizontal: mq.width * .09),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255 , 74, 183, 74),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                widget.message.msg,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),

            ],
          ),
        ),
        Text(time(),
          style: TextStyle(
              color: Colors.black.withOpacity(.5), fontSize: 11),
          textAlign:TextAlign.center,),
        const SizedBox(width: 15,)

      ],
    );
  }

  Widget _sendMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(right: mq.height * .02 , top: 5),
          padding: EdgeInsets.symmetric(
              vertical: mq.height * .01, horizontal: mq.width * .09),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.green,width: 2),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                widget.message.msg,
                style: const TextStyle(color: Colors.black, fontSize: 15),
              ),

            ],
          ),
        ),
        Text(time(),
          style: TextStyle(
              color: Colors.black.withOpacity(.5), fontSize: 11),
          textAlign:TextAlign.center,),
        const SizedBox(width: 15,)

      ],
    );
  }

  String time(){
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(widget.message.sent));

    // Format the DateTime to 12-hour format
    final formatter = DateFormat('hh:mm a'); // 'hh' for 12-hour, 'a' for AM/PM
    final formattedTime = formatter.format(dateTime);
    return formattedTime;
  }
}