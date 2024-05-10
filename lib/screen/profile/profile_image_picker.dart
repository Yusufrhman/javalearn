import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({super.key, required this.onSelectImage});
  final void Function(File image) onSelectImage;

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _selectedImage;
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onSelectImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    final userData = FirebaseAuth.instance.currentUser!;
    var content = userData.photoURL != null
        ? Image.network(
            userData.photoURL!,
            height: 130,
            width: 130,
            fit: BoxFit.cover,
          )
        : Image.asset(
            "assets/images/profile.png",
            height: 130,
            width: 130,
            fit: BoxFit.cover,
          );
    if (_selectedImage != null) {
      content = Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
      );
    }
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0.5, color: const Color.fromARGB(255, 104, 16, 136)),
              borderRadius: BorderRadius.circular(100),
            ),
            width: MediaQuery.of(context).size.height * 0.15,
            height: MediaQuery.of(context).size.height * 0.15,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100), child: content),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.05,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 104, 16, 136)),
              child: IconButton(
                onPressed: _pickImage,
                icon: const Icon(
                  Icons.camera_alt,
                  size: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
