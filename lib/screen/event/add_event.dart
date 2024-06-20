import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  String _enteredTitle = '';
  String _enteredDescription = '';
  String _enteredLocation = '';
  bool _isLoading = false;

  File? _selectedImage;

  DateTime? _pickedDate;
  DateTime _selectedDate = DateTime.now();
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  final uuid = Uuid();

  void _submit() async {
    final _currentUser = FirebaseAuth.instance.currentUser!;
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_selectedImage == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();
    final eventId = uuid.v4();
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('event_images')
          .child('$eventId.jpg');
      await storageRef.putFile(_selectedImage!);
      final _imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance.collection('events').doc(eventId).set(
        {
          'userId': _currentUser.uid,
          'author': _currentUser.displayName ?? "",
          'title': _enteredTitle,
          'description': _enteredDescription,
          'date': _selectedDate.toIso8601String(),
          'location': _enteredLocation,
          'image_url': _imageUrl,
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
          'Add Events',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                                  width: 0,
                                  color: Color.fromARGB(255, 104, 16, 136)),
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
                                  width: 0,
                                  color: Color.fromARGB(255, 104, 16, 136)),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final imagePicker = ImagePicker();
                          final pickedImage = await imagePicker.pickImage(
                              source: ImageSource.camera, maxWidth: 600);
                          if (pickedImage == null) {
                            return;
                          }
                          setState(() {
                            _selectedImage = File(pickedImage.path);
                          });
                        },
                        child: Container(
                            height: 100,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: _selectedImage == null
                                ? Icon(Icons.image)
                                : Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                              onPressed: () async {
                                _pickedDate = await showOmniDateTimePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: _selectedDate,
                                  is24HourMode: true,
                                );
                                if (_pickedDate != null) {
                                  setState(() {
                                    _selectedDate = _pickedDate!;
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.white)),
                              label: Text(inputFormat.format(_selectedDate)),
                              icon: Icon(
                                Icons.calendar_month,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Location",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a Location";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enteredLocation = newValue!;
                        },
                        maxLines: 3,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                          contentPadding: const EdgeInsets.all(18),
                          hintText: "Location",
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 0, color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 0,
                                  color: Color.fromARGB(255, 104, 16, 136)),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      FilledButton(
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
    ;
  }
}
