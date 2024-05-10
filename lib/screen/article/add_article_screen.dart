import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/models/article.dart';
import 'package:javalearn/widget/article/article_image_picker.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  bool _isNoImage = false;
  bool _isLoading = false;
  String _enteredTitle = '';
  String _enteredDescription = '';
  Category _selectedCategory = Category.art;

  final _currentUser = FirebaseAuth.instance.currentUser!;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_selectedImage == null) {
      setState(() {
        _isNoImage = true;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();
    final articleId = uuid.v4();
    var _currentDate = DateTime.now().toString();
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('article_images')
          .child('$articleId.jpg');
      await storageRef.putFile(_selectedImage!);
      final _imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .set(
        {
          'userId': _currentUser.uid,
          'author': _currentUser.displayName,
          'title': _enteredTitle,
          'description': _enteredDescription,
          'image_url': _imageUrl,
          'category': _selectedCategory.name,
          'date_added': _currentDate,
          'liked_by': [],
          'status' : 'waiting'
        },
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .update({
        'articles': FieldValue.arrayUnion([articleId])
      });

      setState(() {
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          'Add Article',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredTitle = newValue!;
                  },
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    contentPadding: const EdgeInsets.all(18),
                    hintText: "Title",
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 0, color: Color.fromARGB(255, 104, 16, 136)),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Description",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a Description";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredDescription = newValue!;
                  },
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    contentPadding: const EdgeInsets.all(18),
                    hintText: "Description",
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 0, color: Color.fromARGB(255, 104, 16, 136)),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Category",
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase()),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(
                                () {
                                  _selectedCategory = value;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Image",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                ArticleImagePicker(
                  onSelectImage: (image) {
                    _selectedImage = image;
                  },
                  isNoImage: _isNoImage,
                ),
                const SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : FilledButton(
                        style: ButtonStyle(
                            side: const MaterialStatePropertyAll(
                                BorderSide(color: Colors.grey)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            fixedSize: const MaterialStatePropertyAll(
                                Size.fromWidth(370)),
                            padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 20),
                            ),
                            backgroundColor: const MaterialStatePropertyAll(
                              Color.fromARGB(255, 104, 16, 136),
                            )),
                        onPressed: () {
                          _submit();
                        },
                        child: Text(
                          "Submit",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
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
