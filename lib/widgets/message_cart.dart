import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pro_chat/api/apis.dart';
import 'package:pro_chat/model/message_model.dart';

class CustomMessageCard extends StatefulWidget {
  final MessageModel message;

  CustomMessageCard({super.key, required this.message});

  @override
  State<CustomMessageCard> createState() => _CustomMessageCardState();
}

class _CustomMessageCardState extends State<CustomMessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  // Sender or other user text
  Widget _blueMessage() {
    if(widget.message.read.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: widget.message.type == Type.text ?
            Text(
              widget.message.msg,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ) : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.message.msg,
                placeholder: (context, url){
                  return CircularProgressIndicator(strokeWidth: 2,);
                },
                errorWidget: (context, url, error) {
                  return Icon(Icons.image, size: 70,);
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: 10,
          ),
          child: Text(
            "${Jiffy.parse("${DateTime.fromMillisecondsSinceEpoch(int.parse(widget.message.sent))}").format(pattern: "hh:mm a")}",
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // Our or user text
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 10,
          ),
          child: Row(
            children: [
              if (widget.message.read.isNotEmpty)
                Icon(
                  Icons.done_all_rounded,
                  color: Colors.purple,
                ),
              SizedBox(
                width: 3,
              ),
              Text(
                "${Jiffy.parse("${DateTime.fromMillisecondsSinceEpoch(int.parse(widget.message.sent))}").format(pattern: "hh:mm a")}",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              border: Border.all(color: Colors.purple),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child:
            widget.message.type == Type.text ?
            Text(
              widget.message.msg,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ) : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.message.msg,
                placeholder: (context, url){
                  return CircularProgressIndicator(strokeWidth: 2,);
                },
                errorWidget: (context, url, error) {
                  return Icon(Icons.image, size: 70,);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
