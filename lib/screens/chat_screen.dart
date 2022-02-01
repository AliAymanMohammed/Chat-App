import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
   var fbm = FirebaseMessaging.instance;
   FirebaseMessaging.onMessage.listen((event) {
    print( event.notification.title);
     print(event.notification.body);
   });
   FirebaseMessaging.onMessageOpenedApp.listen((event) {
     print(event.notification.title);
   });
   // FirebaseMessaging.onBackgroundMessage((message){
   //   print(message.notification.title);
   //   print(message.notification.body);
   //   return;
   // });
 fbm.requestPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatz'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Row(
                  children: const [
                     Icon(Icons.exit_to_app , color: Colors.pinkAccent,),
                     SizedBox(width: 8,),
                    Text('LogOut'),
                  ],
                ),
                value: 'LogOut',
              ),
            ],
            onChanged: (item){
              if(item == 'LogOut'){
                FirebaseAuth.instance.signOut();
              }
            },
            icon:  Icon(Icons.more_vert ,color: Theme.of(context).primaryIconTheme.color,),),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
