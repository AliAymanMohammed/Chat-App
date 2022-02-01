import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  final String message;
  final String userName;
  final bool isMe;
  final String userImage;

  MessageBubble(this.message , this.isMe, this.userName , this.userImage);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start ,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.only(
                  topRight: const Radius.circular(12),
                  topLeft:  const Radius.circular(12),
                  bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(12),
                  bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                ),
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              ),
              width: 150,
              margin: const EdgeInsets.symmetric(vertical: 16 , horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 16),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(userName , style: const TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  Text(message ,style: TextStyle(
                    color:  isMe ? Colors.black : Theme.of(context).primaryTextTheme.headline1.color,
                  ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
            left: isMe ? null : 130,
            right: isMe ? 130 : null,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(userImage) ,
            ),
        ),
      ],
          clipBehavior: Clip.none,
    );
  }
}
