import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:javalearn/models/article.dart';
import 'package:javalearn/widget/article/article_image_picker.dart';
import 'package:uuid/uuid.dart';

class EditArticleScreen extends StatefulWidget {
  const EditArticleScreen({super.key, required this.article});
  final Article article;

  @override
  State<EditArticleScreen> createState() => _EditArticleScreenState();
}

class _EditArticleScreenState extends State<EditArticleScreen> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _enteredTitle = '';
  String _enteredDescription = '';
  Category _selectedCategory = Category.art;

  final _currentUser = FirebaseAuth.instance.currentUser!;

  void _update() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();
    var _currentDate = DateTime.now().toString();
    try {
      var _imageUrl = widget.article.imageUrl;
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('article_images')
            .child(widget.article.id);
        await storageRef.putFile(_selectedImage!);
        _imageUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.article.id)
          .update(
        {
          'userId': _currentUser.uid,
          'author': _currentUser.displayName,
          'title': _enteredTitle,
          'description': _enteredDescription,
          'image_url': _imageUrl,
          'category': _selectedCategory.name,
          'date_added': _currentDate,
          'status': 'waiting'
        },
      );

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
  void initState() {
    _selectedCategory = widget.article.category;

    super.initState();
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Edit Article',
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
                  initialValue: widget.article.title,
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
                  initialValue: widget.article.description,
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
                  isNoImage: false,
                  currentImageUrl: widget.article.imageUrl,
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
                            side: const WidgetStatePropertyAll(
                                BorderSide(color: Colors.grey)),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            fixedSize: const WidgetStatePropertyAll(
                                Size.fromWidth(370)),
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 20),
                            ),
                            backgroundColor: const WidgetStatePropertyAll(
                              Color.fromARGB(255, 104, 16, 136),
                            )),
                        onPressed: () {
                          _update();
                        },
                        child: Text(
                          "Update",
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
