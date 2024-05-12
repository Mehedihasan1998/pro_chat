import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pro_chat/api/apis.dart';
import 'package:pro_chat/authentication/login.dart';
import 'package:pro_chat/model/user_model.dart';
import 'package:pro_chat/widgets/customCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _signOut() async {
    await APIs.auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  List<UserModel> list = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          leading: Icon(Icons.menu),
          title: Text(
            "Pro Chat",
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  _signOut();
                },
                icon: Icon(Icons.logout_rounded)),
          ],
        ),
        body: StreamBuilder(
          stream: APIs.fireStore.collection('users').snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data!.docs;
                list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
                // for (var i in data) {
                //   print(
                //       '\n------------Data--------------: ${jsonEncode(i.data())}');
                //   list.add(i.data()['name']);
                // }
            }

            if(list.isNotEmpty){
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: size.height * 0.01),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CustomCard(user: list[index],);
                  // return Text("Name: ${list[index]}");
                },
              );
            }else{
              return const Center(child: Text("No connections found!", style: TextStyle(fontSize: 20,),));
            }
          },
        ),
      ),
    );
  }
}
