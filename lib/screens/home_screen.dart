import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pro_chat/api/apis.dart';
import 'package:pro_chat/model/user_model.dart';
import 'package:pro_chat/screens/profile_page.dart';
import 'package:pro_chat/widgets/customCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> _list = [];
  final List<UserModel> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getPersonalData();
  }

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
            title: _isSearching
                ? TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Name, Email ..."),
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    onChanged: (value) {
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : Text(
                    "Pro Chat",
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching ? CupertinoIcons.clear_circled : Icons.search,
                  color: Colors.purple,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            user: APIs.myData,
                          )));
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
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
                  _list =
                      data.map((e) => UserModel.fromJson(e.data())).toList();

                // _list =
                //     data?.map((e) => UserModel.fromJson(e.data())).toList()??[];

                // for (var i in data) {
                //   print(
                //       '\n------------Data--------------: ${jsonEncode(i.data())}');
                //   _list.add(i.data()['name']);
                // }
              }

              if (_list.isNotEmpty) {
                return ListView.builder(
                  itemCount: _isSearching ? _searchList.length : _list.length,
                  padding: EdgeInsets.only(top: size.height * 0.01),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CustomCard(
                      user: _isSearching ? _searchList[index] : _list[index],
                    );
                    // return Text("Name: ${_list[index]}");
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
      ),
    );
  }


}
