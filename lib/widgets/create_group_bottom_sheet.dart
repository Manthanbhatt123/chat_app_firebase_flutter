
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';

class GroupCreateBottomSheet extends StatefulWidget {
  const GroupCreateBottomSheet({super.key});

  @override
  State<GroupCreateBottomSheet> createState() => _GroupCreateBottomSheetState();
}

class _GroupCreateBottomSheetState extends State<GroupCreateBottomSheet> {
  final TextEditingController _groupNameController = TextEditingController();
  final List<String> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  // Save group data to Firestore
  void _saveGroupToFirestore() async {
    if (_groupNameController.text.isNotEmpty && _selectedMembers.isNotEmpty) {
      final groupid = '${APIs.myUser.uid}-${_groupNameController.text}';
      final groupData = {
        'group_id': groupid,
        'created_at': Timestamp.now(),
        'last_message': 'Hello',
        'last_message_time': Timestamp.now(),
        'members': _selectedMembers,
        'name': _groupNameController.text,
      };

      APIs.createGroup(groupData);
      // Close the bottom sheet after successful creation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Group created successfully!")),
      );
      Navigator.pop(context); // Close the bottom sheet
    } else {
      // Handle validation (group name or members not selected)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close the bottom sheet if tapped outside
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.transparent, // Makes the gesture detector area transparent
        child: GestureDetector(
          onTap: () {}, // Prevent tap events inside the bottom sheet from closing it
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _groupNameController,
                      decoration: const InputDecoration(
                        labelText: "Group Name",
                        labelStyle: TextStyle(color: Colors.green),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Select Group Members"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5, // Example, replace with dynamic data
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          activeColor: Colors.green,
                          title: Text("User $index"),
                          value: _selectedMembers.contains("User $index"),
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedMembers.add("User $index");
                              } else {
                                _selectedMembers.remove("User $index");
                              }
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveGroupToFirestore,
                      child: const Text("Create Group"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}