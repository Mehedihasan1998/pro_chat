import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pro_chat/api/apis.dart';
import 'package:pro_chat/authentication/login.dart';
import 'package:pro_chat/model/user_model.dart';
import 'package:pro_chat/screens/profile_page.dart';
import 'package:pro_chat/widgets/customCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> list = [];

  @override
  void initState() {
    super.initState();
    APIs.getPersonalData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/icon.png',
                      height: size.height * 0.044,
                      width: size.height * 0.044,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ],
          ),
          title: Text(
            "Pro Chat",
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.purple,)),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          user: APIs.myData,
                        )));
              },
              icon: Icon(Icons.person, color: Colors.purple,),
            ),
          ],
        ),
        body: StreamBuilder(
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
                final data = snapshot.data!.docs;
                list =
                    data?.map((e) => UserModel.fromJson(e.data())).toList() ??
                        [];
              // for (var i in data) {
              //   print(
              //       '\n------------Data--------------: ${jsonEncode(i.data())}');
              //   list.add(i.data()['name']);
              // }
            }

            if (list.isNotEmpty) {
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: size.height * 0.01),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CustomCard(
                    user: list[index],
                  );
                  // return Text("Name: ${list[index]}");
                },
              );
            } else {
              return const Center(
                  child: Text(
                "No connections found!",
                style: TextStyle(
                  fontSize: 20,
                ),
              ));
            }
          },
        ),
      ),
    );
  }
}
