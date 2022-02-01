import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final messageController = TextEditingController();
  var enteredMessage = '';

  void sendMessage()async{
    FocusScope.of(context).unfocus();
    final user =   FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    FirebaseFirestore.instance.collection('chats').add({
      'text' : enteredMessage,
      'sentAt' : Timestamp.now(),
      'userId' : user.uid,
      'userName' : userData['userName'],
      'userImage' : userData['imageUrl'],
    });
    messageController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(child: TextField(
            controller:messageController ,
            decoration: const InputDecoration(
              labelText: 'Send Message',
            ),
            onChanged: (value){
              setState(() {
                enteredMessage = value;
              });
            },
          ),
          ),
          IconButton(onPressed: (){
            enteredMessage.trim().isEmpty ? null : sendMessage();
          }
          ,icon: const Icon(Icons.send),color: Theme.of(context).primaryColor,),
        ],
      ),
    );
  }
}
