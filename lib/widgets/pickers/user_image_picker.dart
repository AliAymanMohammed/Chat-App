import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  final  Function (File image) submitImage;
  UserImagePicker(this.submitImage);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File userImage;
  var picker = ImagePicker();
  void pickFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      userImage = File(pickedFile.path);
    });
    widget.submitImage(userImage);
  }

  void pickFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      userImage = File(pickedFile.path);
    });
    widget.submitImage(userImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: userImage != null
              ? FileImage(userImage)
              : const NetworkImage(
                  'https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1223671392?s=612x612'),

        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: () {
                pickFromCamera();
              },
              icon: const Icon(Icons.camera),
              label: const Text('Camera'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: () {
                pickFromGallery();
              },
              icon: const Icon(Icons.image),
              label: const Text('Gallery'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
