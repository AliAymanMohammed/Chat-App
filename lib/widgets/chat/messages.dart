import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('sentAt' , descending: true)
            .snapshots(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapShot.hasData) {
            return ListView.builder(
              reverse: true,
              itemBuilder: (context, index) =>
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: MessageBubble(
                        snapShot.data.docs[index]['text'] ,
                        snapShot.data.docs[index]['userId'] == user.uid ,
                        snapShot.data.docs[index]['userName'] ,
                        snapShot.data.docs[index]['userImage'],
                    ),
                  ),
              itemCount: snapShot.data.docs.length,
            );
          }
          return Container();
        });
  }
}
