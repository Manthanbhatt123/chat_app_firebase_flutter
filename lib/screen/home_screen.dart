import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sarthak/screen/user_profile.dart';

import '../api/api.dart';
import '../models/chat_user.dart';
import '../models/group.dart';
import '../widgets/chat_user_card.dart';
import '../widgets/create_group_bottom_sheet.dart';
import '../widgets/group_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<ChatUser> _list = [];
  List<Group> groups = [];
  final List<ChatUser> _searchList = [];
  final List<Group> _searchGroup = [];
  bool _isSearching = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    APIs.selfInfo();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs: One-on-One and Group Chat
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.9),
          appBar: AppBar(
            toolbarHeight: 70,
            title: _isSearching
                ? TextField(
              decoration: _tabController.index==0 ?
              const InputDecoration(
                border: InputBorder.none,
                hintText: "Name,email,...",
              ) :const InputDecoration(
                border: InputBorder.none,
                hintText: "group name..",
              ) ,
              autofocus: true,
              style: const TextStyle(fontSize: 16, letterSpacing: .5),
              onChanged: (val) => {
                _searchList.clear(),
                _searchGroup.clear(),
                if(_tabController.index == 0){
                  for (var i in _list)
                    {
                      if (i.name
                          .toLowerCase()
                          .contains(val.toLowerCase())  ||
                          i.email.toLowerCase().contains(val.toLowerCase()))
                        {_searchList.add(i)},
                      setState(() {
                        _searchList;
                      })
                    }
                } else {
                  for (var i in groups)
                    {
                      if (i.name
                          .toLowerCase()
                          .contains(val.toLowerCase()) ||
                          i.name.toLowerCase().contains(val.toLowerCase()))
                        {_searchGroup.add(i)},
                      setState(() {
                        _searchGroup;
                      })
                    }
                }
              },
            )
                : const Text(
              "Chat App",
              style: TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              tabs: const [
                Tab(text: 'One-on-One Chat',),
                Tab(text: 'Group Chat'),
              ],
              indicatorColor: Colors.white,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if(_isSearching){
                      _searchList.clear();
                      _searchGroup.clear();
                    }
                  });
                },
                icon: Icon(_isSearching ? Icons.close_rounded : Icons.search),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserProfile(user: APIs.me),
                    ),
                  );
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 11.0, right: 11.0),
            child: FloatingActionButton(
              onPressed: () {
                log("message");
                if (_tabController.index == 1){
                  _openGroupCreateBottomSheet();
                }
              },
              backgroundColor: Colors.green,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildChatListView(), // One-on-One Chat
              _buildGroupChatListView(), // Group Chat
            ],
          ),
        ),
      ),
    );
  }

// Open BottomSheet to create a new group
  void _openGroupCreateBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const GroupCreateBottomSheet();
      },
    );
  }
  Widget _buildChatListView() {
    return StreamBuilder(
      stream: APIs.getAllUsers(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data?.docs;
              _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
            }

            if (_list.isNotEmpty) {
              return ListView.builder(
                itemCount: _isSearching ? _searchList.length : _list.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 8),
                itemBuilder: (context, index) {
                  return ChatUserCard(
                    user: _isSearching ? _searchList[index] : _list[index],
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  "No one-on-one chats yet!",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
        }
      },
    );
  }

  Widget _buildGroupChatListView() {
    return StreamBuilder(
      stream: APIs.getAllGroups(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data?.docs;
              data?.forEach((action){
                log("Groups \n ${action.data()}");
              });
              groups = data?.map((e) => Group.fromJson(e.data())).toList() ?? [];

            }
            if (groups.isNotEmpty) {
              final groupId = FirebaseFirestore.instance.collection('groups').doc() ;
              print(groupId);

              return ListView.builder(
                itemCount: _isSearching ? _searchGroup.length : groups.length,
                physics: const BouncingScrollPhysics() ,
                padding: const EdgeInsets.only(top: 8),
                itemBuilder: (context, index) {
                  return GroupUserCard(group:_isSearching ? _searchGroup[index] : groups[index]);
                },
              );
            } else {
              return const Center(
                child: Text(
                  "Click on + button to Start Group chat ",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
        }
      },
    );
  }
}