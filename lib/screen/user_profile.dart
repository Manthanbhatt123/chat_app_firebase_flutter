
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/api.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'login_screen.dart';

class UserProfile extends StatefulWidget {
  final ChatUser user;

  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  File? _avatar;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white70.withOpacity(0.92),
        appBar: AppBar(
          toolbarHeight: mq.height * .07,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "User Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 11.0, right: 11.0),
          child: FloatingActionButton.extended(
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await APIs.auth.signOut().then((_) => {
                Navigator.pop(context),
                Navigator.pop(context),
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()))
              });
            },
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            backgroundColor: Colors.redAccent,
            label: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: mq.height * .05),
                Stack(
                  children: [
                    ClipOval(
                      child: _avatar != null
                          ? Image.file(
                        _avatar!,
                        width: mq.height * .2,
                        height: mq.height * .2,
                        fit: BoxFit.cover,
                      )
                          : CircleAvatar(
                        radius: mq.height * .1,
                        backgroundColor: Colors.green,
                        child: const Icon(
                          Icons.person,
                          size: 115,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: _showBottomSheet,
                        shape: const CircleBorder(),
                        color: Colors.white,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mq.height * .03),
                Text(
                  widget.user.name,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: mq.height * .03),
                TextFormField(
                  onSaved: (val) => {APIs.me.name = val ?? ''},
                  validator: (val) =>
                  val != null && val.isNotEmpty ? null : "Required",
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.green),
                    hintText: "eg: John",
                    hintStyle: TextStyle(color: Colors.black26),
                    label: Text("Name", style: TextStyle(color: Colors.green)),
                  ),
                ),
                SizedBox(height: mq.height * .02),
                TextFormField(
                  onSaved: (val) => {APIs.me.about = val ?? ''},
                  validator: (val) =>
                  val != null && val.isNotEmpty ? null : "Required",
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.info_outline, color: Colors.green),
                    hintText: "eg: Enthusiastic developer",
                    hintStyle: TextStyle(color: Colors.black26),
                    label: Text("About", style: TextStyle(color: Colors.green)),
                  ),
                ),
                SizedBox(height: mq.height * .02),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                  ),
                  label: const Text(
                    "Update",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      APIs.updateUserInfo().then((_) =>
                          Dialogs.snackBar(context, "User profile updated"));
                    }
                  },
                ),
                SizedBox(height: mq.height * .07),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPolicyDialog(
                          context, 'Privacy Policy', "By using this app, you agree to follow the rules. "
                          "Be respectful and don’t share harmful, illegal, or inappropriate content. "
                          "Your personal information is kept private,"
                          " but some data may be used to improve the app. "
                          "Keep your account details safe and don’t share them with anyone.");
                    });
                  },
                  child: const Text(
                    'Privacy',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
                SizedBox(height: mq.height * .01),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPolicyDialog(context, 'Terms & Conditions',
                          "By using this app, you agree to follow the rules. "
                              "Be respectful and don’t share harmful, illegal, or inappropriate content. "
                              "Your personal information is kept private,"
                              " but some data may be used to improve the app. "
                              "Keep your account details safe and don’t share them with anyone.");
                    });
                  },
                  child: const Text(
                    'TERMS & CONDITIONS',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showPolicyDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding:
          EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .05),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Text(
                "Image Picker",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () =>
                  {
                    /* _pickImage(ImageSource.gallery)*/
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 35),
                    backgroundColor: Colors.green,
                  ),
                  child: const Icon(Icons.photo, color: Colors.white, size: 25),
                ),
                ElevatedButton(
                  onPressed: () =>
                  {
                    /*_pickImage(ImageSource.camera)*/
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 35),
                    backgroundColor: Colors.green,
                  ),
                  child: const Icon(Icons.camera, color: Colors.white, size: 25),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

 /* Future<void> _pickImage(ImageSource source) async {
    bool permissionGranted = await checkPermissions(source);
    if (permissionGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _avatar = File(image.path);
        });
      }
    } else {
      Dialogs.snackBar(context,
          "Permission denied. Cannot Access ${source == ImageSource.camera ? 'Camera' : 'Gallery'}");
    }
    Navigator.pop(context);
  }

  Future<bool> checkPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        PermissionStatus result = await Permission.camera.request();
        return result.isGranted;
      }
      return true;
    } else {
      PermissionStatus galleryStatus = await Permission.photos.status;
      if (!galleryStatus.isGranted) {
        PermissionStatus result = await Permission.photos.request();
        return result.isGranted;
      }
      return true;
    }
  }*/
}