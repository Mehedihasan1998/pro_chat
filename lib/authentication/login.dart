import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pro_chat/api/apis.dart';
import 'package:pro_chat/screens/home_screen.dart';
import 'package:pro_chat/widgets/dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _googleSignIn() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) {
      Navigator.pop(context);
      if (user != null) {
        print("\nUser: ${user.user}");
        print("\nUserAdditionalInfo: ${user.additionalUserInfo}");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      print("Error: $e");
      Dialogs.showSnackbar(context, "Check the internet and try again");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pro Chat",
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: Stack(
          children: [
            Positioned(
              top: size.height * .15,
              left: size.width * .25,
              width: size.width * .5,
              child: Image.asset(
                "assets/images/icon.png",
              ),
            ),
            Positioned(
              bottom: size.height * .15,
              left: size.width * .05,
              width: size.width * .9,
              height: size.height * 0.08,
              child: MaterialButton(
                color: Colors.greenAccent.shade700,
                shape: StadiumBorder(),
                onPressed: () {
                  _googleSignIn();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/google.png",
                      height: size.height * .04,
                      width: size.width * .1,
                    ),
                    SizedBox(
                      width: 22,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Login with ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                        children: const <TextSpan>[
                          TextSpan(
                            text: "Google",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
