import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pro_chat/api/apis.dart';
import 'package:pro_chat/authentication/login.dart';
import 'package:pro_chat/model/user_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_rounded, color: Colors.purple,),
          ),
          title: Text(
            "Pro Chat",
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Padding(
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(size.height * 0.1),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        elevation: 1,
                        onPressed: () {},
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
                TextFormField(
                  initialValue: widget.user.name,
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
                TextFormField(
                  initialValue: widget.user.about,
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    minimumSize: Size(size.width * .5, size.height * .06),
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () {},
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
    );
  }
}
