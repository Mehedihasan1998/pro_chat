import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pro_chat/api/apis.dart';
import 'package:pro_chat/model/message_model.dart';
import 'package:pro_chat/model/user_model.dart';
import 'package:pro_chat/screens/chat_screen.dart';

class CustomCard extends StatefulWidget {
  final UserModel user;

  const CustomCard({super.key, required this.user});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  MessageModel? message;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChatScreen(
                  user: widget.user,
                )));
      },
      child: Card(
        margin:
            EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 1,
        child: StreamBuilder(
            stream: APIs.getLastText(widget.user),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:

                  /// Can user Shimmer
                  return LinearProgressIndicator(
                    minHeight: 10,
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data!.docs;
                  final list =
                      data.map((e) => MessageModel.fromJson(e.data())).toList();
                  if (list.isNotEmpty) {
                    message = list[0];
                  }
              }
              return ListTile(
                // leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(size.height * 0.3),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: size.height * 0.055,
                    width: size.height * 0.055,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) {
                      return const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      );
                    },
                  ),
                ),
                title: Text(widget.user.name),
                subtitle: Text(
                  message != null ? message!.msg : widget.user.about,
                  maxLines: 1,
                ),
                trailing: message == null
                    ? null
                    : message!.read.isEmpty && message!.fromId != APIs.user.uid
                        ? Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                        : Text(
                            "${Jiffy.parse("${DateTime.fromMillisecondsSinceEpoch(int.parse(message!.sent))}").format(pattern: "hh:mm a")}",
                            style:
                                TextStyle(fontSize: 13, color: Colors.black54),
                          ),
              );
            }),
      ),
    );
  }
}
