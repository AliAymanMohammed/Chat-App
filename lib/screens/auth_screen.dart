import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLoading = false;

  void submitAuthForm(
    String email,
    String userName,
    File image,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authRes;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authRes = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        authRes = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      }
      final ref =  FirebaseStorage.instance.ref().child('userImage').child(authRes.user.uid + '.jpg');
      await ref.putFile(image).whenComplete(() async{
        final imageUrl = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authRes.user.uid)
            .set({
          'userName': userName,
          'email': email,
          'imageUrl' : imageUrl,
        });
      });


      // final ref = FirebaseStorage.instance
      //     .ref()
      //     .child('userImages')
      //     .child(authRes.user.uid + '.jpg');
      // await ref.putFile(image).whenComplete(()async{
      //   final imageUrl = await ref.getDownloadURL();
      //   await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(authRes.user.uid)
      //       .set({
      //     'userName': userName,
      //     'email': email,
      //     'image' : imageUrl,
      //   });
      // });

    } on PlatformException catch (error) {
      var message = 'An error Occurred , Please check your Credentials';
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitAuthForm, isLoading),
    );
  }
}
