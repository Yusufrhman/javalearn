import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/screen/profile/profile_image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String _name = '';
  String _phone = '';

  final _currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? _userData;
  void _updateProfile() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    dynamic imageUrl;

    try {
      setState(() {
        _isLoading = true;
      });
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child("${_currentUser.uid}.jpg");
      if (_selectedImage == null) {
        imageUrl = _currentUser.photoURL;
      } else {
        await storageRef.putFile(_selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
      }
      await _currentUser.updateDisplayName(_name);
      await _currentUser.updatePhotoURL(imageUrl);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .update({'name': _name, 'phone': _phone, 'image_url': imageUrl});
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: const Text('update Success!'),
          showCloseIcon: true,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: const Text('update Failed!'),
          showCloseIcon: true,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                ProfileImagePicker(onSelectImage: (image) {
                  _selectedImage = image;
                }),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  child: Text(
                    "Email",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  initialValue: _currentUser.email,
                  readOnly: true,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                      ),
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.red),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 104, 16, 136)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 104, 16, 136)),
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 12),
                      child: Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 104, 16, 136),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  child: Text(
                    "Nama",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  initialValue: _currentUser.displayName,
                  validator: (value) {
                    if (value == null || value.trim() == '') {
                      return 'nama tidak boleh kosong!';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _name = newValue!;
                  },
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                      ),
                  decoration: InputDecoration(
                    suffixIcon: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.edit_outlined,
                        color: Color.fromARGB(255, 104, 16, 136),
                      ),
                    ),
                    errorStyle: const TextStyle(color: Colors.red),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 104, 16, 136)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 104, 16, 136)),
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 12),
                      child: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 104, 16, 136),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  child: Text(
                    "No HP",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(_currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      _userData = snapshot.data!.data();
                      return TextFormField(
                        initialValue: _userData?['phone'] ?? '...',
                        onSaved: (newValue) {
                          _phone = newValue!;
                        },
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                        decoration: InputDecoration(
                          suffixIcon: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.edit_outlined,
                              color: Color.fromARGB(255, 104, 16, 136),
                            ),
                          ),
                          errorStyle: const TextStyle(color: Colors.red),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 104, 16, 136)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 104, 16, 136)),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 12),
                            child: Icon(
                              Icons.phone_android,
                              color: Color.fromARGB(255, 104, 16, 136),
                            ),
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 40,
                ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 104, 16, 136),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            _updateProfile();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "Update",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
