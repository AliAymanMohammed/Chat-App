import 'dart:io';

import 'package:flutter/material.dart';
import '/widgets/pickers/user_image_picker.dart';
class AuthForm extends StatefulWidget {

  final void Function(
      String email,
      String userName,
      File image,
      String password,
      bool isLogin,
      BuildContext context,) submit;
  final bool isLoading;
  AuthForm(this.submit ,this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final formKey = GlobalKey<FormState>();

  var isLogin = true;
  var userEmail = '';
  var userName = '';
  var userPassword = '';
  File userImage;
  void pickedImage(File image){
    userImage = image;
  }
  void submit(){
    final isValid = formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(userImage == null && !isLogin){
      Scaffold.of(context).showSnackBar( SnackBar(content: const Text('Please Select An Image'),backgroundColor: Theme.of(context).errorColor,));
      return ;
    }
    if(isValid){
      formKey.currentState.save();
      widget.submit(userEmail.trim(),userName,userImage ,userPassword.trim(),isLogin ,context );

    }
  }
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(!isLogin)
               UserImagePicker(pickedImage),
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText:  'Email Address',
                  ),
                  validator: (value){
                  if(value.isEmpty || !value.contains('@')){
                    return 'Please Enter A Valid Email';
                  }
                  return null;
                  },
                  onSaved: (value){
                    userEmail = value;
                  },
                ),
                if(!isLogin)
                TextFormField(
                  key: const ValueKey('userName'),
                  decoration: const InputDecoration(
                    labelText: 'User Name'
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'Please Enter A Name';
                    }
                    return null;
                  },
                  onSaved: (value){
                    userName = value;
                  },
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  decoration: const InputDecoration(
                    labelText: 'Password'
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value){
                    if(value.length < 7 ){
                      return 'Password Must Be at Least 7 Characters Long';
                    }
                    return null;
                  },
                  onSaved: (value){
                    userPassword = value;
                  },
                ),
                const SizedBox(height: 13,),
                 if(widget.isLoading)
                   const Center(child: CircularProgressIndicator(),),
                 if(!widget.isLoading)
                 RaisedButton(
                   onPressed: (){
                     submit();
                   },
                   child:  Text(isLogin ?'Login' : 'Signup'),),
                if(!widget.isLoading)
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  onPressed: (){
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child:  Text( isLogin ? 'Create New Account':'Have An Account Already'),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
