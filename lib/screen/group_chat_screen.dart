
import 'dart:developer';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../main.dart';
import '../models/group.dart';
import '../models/group_messages.dart';
import '../widgets/group_message_card.dart';

class GroupChatScreen extends StatefulWidget {

  final Group group;
  const GroupChatScreen({
    super.key, required this.group,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _textController = TextEditingController();
  List<Messages> _list = [];

  @override
  Widget build(BuildContext context) {
    log("groupId \n"+widget.group.group_id.toString());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(.9),
          appBar: AppBar(
            toolbarHeight: mq.height * 0.115,
            elevation: 12,
            flexibleSpace: _appBar(),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllGroupMessages(widget.group.group_id),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          // child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:

                        final data = snapshot.data?.docs;

                        _list = data
                            ?.map((e) => Messages.fromJson(e.data()))
                            .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: _list.length,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: mq.height * .02),
                            itemBuilder: (context, index) {
                              return GroupMessageCard(
                                message: _list[index],
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text(
                              "Start chatting!",
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
              _chatInput()
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    String members = '';
    for (var value in widget.group.members) {
      members = '$value ,';
    }
    return Padding(
      padding: EdgeInsets.only(top: mq.height * 0.03),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          SizedBox(width: mq.width * 0.05),
          const Icon(
            Icons.group,
            color: Colors.white,
            size: 25,
          ),
          SizedBox(width: mq.width * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.group.name,
                style: const TextStyle(color: Colors.white, fontSize: 25) ,
              ),
              Text(
                members,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 3,
            shadowColor: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                            const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                            const BorderSide(color: Colors.transparent),
                          ),
                          filled: true,
                          hintText: "Enter message...",
                          hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        MaterialButton(
          minWidth: 1,
          color: Colors.green,
          height: mq.height * .06,
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.green,
            ),
          ),
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              APIs.sendGroupMessage(_textController.text.trim(),widget.group.group_id);

              _textController.text = '';
            }
          },
          child: const Icon(
            Icons.send,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}