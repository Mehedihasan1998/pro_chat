import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pro_chat/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  _googleSignIn(){

    signInWithGoogle().then((user) {
      print("\nUser: ${user.user}");
      print("\nUserAdditionalInfo: ${user.additionalUserInfo}");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pro Chat"),
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
                      height: size.height * .05,
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
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                        children: const <TextSpan>[
                          TextSpan(
                            text: "Google",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
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
