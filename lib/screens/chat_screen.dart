import 'dart:convert';
import 'package:flutter/foundation.dart' as foundation;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pro_chat/api/apis.dart';
import 'package:pro_chat/model/message_model.dart';
import 'package:pro_chat/model/user_model.dart';
import 'package:pro_chat/widgets/message_cart.dart';

class ChatScreen extends StatefulWidget {
  UserModel user;

  ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> _list = [];

  final _textController = TextEditingController();

  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.purple.shade50,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            elevation: 1,
            backgroundColor: Colors.purple.shade50,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.purple,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(size.height * 0.03),
                  child: CachedNetworkImage(
                    height: size.height * 0.05,
                    width: size.height * 0.05,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) {
                      return const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Text(
                      "User last seen at 12:00 PM",
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    )
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.call,
                  color: Colors.purple,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllText(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data!.docs;
                        _list = data
                            .map((e) => MessageModel.fromJson(e.data()))
                            .toList();
                        // final _list = [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: size.height * 0.01),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              // return CustomCard(
                              //   user: _isSearching ? _searchList[index] : _list[index],
                              // );
                              return CustomMessageCard(
                                message: _list[index],
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text(
                            "Say Hi! 👋",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ));
                        }
                    }
                  },
                ),
              ),
              _chatInputField(),
              if (_showEmoji)
                EmojiPicker(
                  textEditingController: _textController,
                  config: Config(
                    height: 256,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      emojiSizeMax: 28 *
                          (foundation.defaultTargetPlatform == TargetPlatform.iOS
                              ?  1.20
                              :  1.0),
                    ),
                    swapCategoryAndBottomBar:  false,
                    skinToneConfig: const SkinToneConfig(),
                    categoryViewConfig: const CategoryViewConfig(),
                    bottomActionBarConfig: const BottomActionBarConfig(),
                    searchViewConfig: const SearchViewConfig(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatInputField() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.025,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.purple,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onTap: (){
                        if(_showEmoji){
                          setState(() {
                            _showEmoji = !_showEmoji;
                          });
                        }
                      },
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Write something...",
                        hintStyle: TextStyle(color: Colors.purple),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.photo,
                      color: Colors.purple,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendText(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, left: 10, right: 5, bottom: 10),
            shape: CircleBorder(),
            color: Colors.purple,
            child: Icon(
              Icons.send,
              size: 26,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
