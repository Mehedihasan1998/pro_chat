import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pro_chat/api/apis.dart';
import 'package:pro_chat/authentication/login.dart';
import 'package:pro_chat/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(seconds: 2),
        (){
          if(APIs.auth.currentUser != null){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
          else{
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/icon.png",
                height: size.height * .4,
                width: size.width * .5,
                fit: BoxFit.contain,
              ),
              RichText(
                text: TextSpan(
                    text: "Created by ",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: const <TextSpan>[
                      TextSpan(
                          text: "Md. Mehedi Hasan",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent, fontSize: 22))
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
