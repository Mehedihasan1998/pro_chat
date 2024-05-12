import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_chat/model/user_model.dart';

class CustomCard extends StatefulWidget {
  final UserModel user;

  const CustomCard({super.key, required this.user});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Card(
        margin:
            EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 1,
        child: ListTile(
          // leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(size.height*0.3),
            child: CachedNetworkImage(
              
              height: size.height * 0.055,
              width: size.height * 0.055,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error){
                return const CircleAvatar(child: Icon(CupertinoIcons.person),);
              },
            ),
          ),
          title: Text(widget.user.name),
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),
          trailing: const Text(
            "12:00 PM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
