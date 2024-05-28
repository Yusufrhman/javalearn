import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ArticleImagePicker extends StatefulWidget {
  ArticleImagePicker(
      {super.key,
      required this.isNoImage,
      required this.onSelectImage,
      this.currentImageUrl});
  final void Function(File image) onSelectImage;
  final bool isNoImage;
  String? currentImageUrl;

  @override
  State<ArticleImagePicker> createState() => _ArticleImagePickerState();
}

class _ArticleImagePickerState extends State<ArticleImagePicker> {
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
    return Ink(
      decoration: BoxDecoration(
          border: !widget.isNoImage
              ? null
              : Border.all(
                  color: const Color.fromARGB(255, 248, 165, 159), width: 1),
          color: const Color.fromARGB(255, 255, 252, 252),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () {
          _pickImage();
        },
        child: SizedBox(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: _selectedImage != null
              ? Image.file(
                  _selectedImage!,
                  fit: BoxFit.contain,
                )
              : widget.currentImageUrl != null
                  ? Image.network(
                      widget.currentImageUrl!,
                      fit: BoxFit.contain,
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          color: Color.fromARGB(255, 104, 16, 136),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Add Photo')
                      ],
                    ),
        ),
      ),
    );
  }
}
