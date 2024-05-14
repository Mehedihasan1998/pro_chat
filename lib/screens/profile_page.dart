import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_chat/api/apis.dart';
import 'package:pro_chat/authentication/login.dart';
import 'package:pro_chat/model/user_model.dart';
import 'package:pro_chat/widgets/dialogs.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _signOut() async {
    await APIs.auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  final _formKey = GlobalKey<FormState>();
  String? _img;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.purple,
              ),
            ),
            title: Text(
              "Pro Chat",
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.05,
                      width: size.width * 1,
                    ),
                    Stack(
                      children: [
                        // Image
                        _img != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.1),
                                child: Image.file(
                                  File(_img!),
                                  fit: BoxFit.cover,
                                  height: size.height * 0.2,
                                  width: size.height * 0.2,
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.1),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: size.height * 0.2,
                                  width: size.height * 0.2,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) {
                                    return const CircleAvatar(
                                      child: Icon(CupertinoIcons.person),
                                    );
                                  },
                                ),
                              ),
                        // Image picker button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showCustomBottomSheet();
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Colors.purple,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    // Name
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.myData.name = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.purple,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "eg. John Martin",
                        label: const Text("Name"),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    //  About
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.myData.about = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.error_outline,
                          color: Colors.purple,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "eg. I am cool!!!",
                        label: const Text("About"),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    // Update Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        minimumSize: Size(size.width * .5, size.height * .06),
                        backgroundColor: Colors.purple,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserData().then((value) {
                            Dialogs.showSnackbar(
                                context, "Profile is updated Successfully");
                          });
                          print("------------Updated user data-------------");
                        }
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 26,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Update",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _signOut();
            },
            shape: StadiumBorder(),
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
            label: Text(
              "Logout",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            backgroundColor: Colors.red,
          ),
        ),
      ),
    );
  }

  void _showCustomBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.03,
              bottom: MediaQuery.of(context).size.height * 0.05,
            ),
            children: [
              const Text(
                "Choose Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Colors.white,
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.2,
                        MediaQuery.of(context).size.height * 0.1,
                      ),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        setState(() {
                          _img = image.path;
                        });

                        APIs.updateProfilePicture(File(_img!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset(
                      "assets/images/galery.png",
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Colors.white,
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.2,
                        MediaQuery.of(context).size.height * 0.1,
                      ),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        setState(() {
                          _img = image.path;
                        });

                        APIs.updateProfilePicture(File(_img!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset(
                      "assets/images/camera.png",
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
