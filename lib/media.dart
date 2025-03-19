// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staff_app/main.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _postcontroller = TextEditingController();

  // Pick multiple images
  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  // Upload images to Supabase and save in tbl_post
  Future<void> _mediaupload() async {
    try {
      String userId = supabase.auth.currentUser!.id;

      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please select at least one image.")));
        return;
      }

      // Upload images and get their URLs
      List<String> photoUrls = await _uploadImages(_images, userId);

      // Insert each image as a new row in tbl_post
      for (String url in photoUrls) {
        await supabase.from("tbl_post").insert({
          'post_file': url, // Single image per row
          'staff_id': userId,
          'post_title': _postcontroller.text
        });
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Posts Added")));

      // Clear the selected images
      setState(() {
        _images.clear();
        _postcontroller.clear();
      });
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // Upload images to Supabase and return their URLs
  Future<List<String>> _uploadImages(List<File> images, String userId) async {
    List<String> uploadedUrls = [];

    try {
      for (File image in images) {
        final fileName =
            'post_$userId-${DateTime.now().millisecondsSinceEpoch}';
        await supabase.storage.from('post').upload(fileName, image);
        final imageUrl = supabase.storage.from('post').getPublicUrl(fileName);
        uploadedUrls.add(imageUrl);
      }
    } catch (e) {
      print('Image upload failed: $e');
    }

    return uploadedUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade400,
          actions: [
            Text(
              "Nurtura",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'AmsterdamThree',
                fontSize: 40,
              ),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/image.png'),
            ),
            SizedBox(width: 20),
          ],
        ),
        body: Form(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Column(
                children: [
                  Text('Upload Post',
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Croist',
                          color: Colors.deepPurple)),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImages,
                      child: DottedBorder(
                        color: Colors.deepPurple,
                        strokeWidth: 2,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        dashPattern: [6, 3],
                        child: Card(
                          shadowColor: Colors.deepPurple,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: _images.map((image) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(
                                      image,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _images.isEmpty
                                      ? 'Click here to upload'
                                      : '${_images.length} image(s) selected',
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontFamily: 'Lato',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          TextFormField(
                              controller: _postcontroller,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: 'Post Name',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Lato',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.deepPurple)))),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple[300],
                            ),
                            onPressed: () {
                              _mediaupload();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Upload',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )));
  }
}
