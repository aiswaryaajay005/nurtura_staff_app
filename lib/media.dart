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
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _postcontroller = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    print(pickedFile);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _mediaupload() async {
    try {
      String userId = supabase.auth.currentUser!.id;
      String? photoUrl;
      if (_image != null) {
        photoUrl = await _uploadImage(_image!, userId);
      }

      await supabase.from("tbl_post").insert({
        'post_file': photoUrl,
        'staff_id': userId,
        'post_title': _postcontroller.text
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Post Added")));
    } catch (e) {
      print("Error:$e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:$e")));
    }
  }

  Future<String?> _uploadImage(File image, String userId) async {
    try {
      final fileName = 'post_$userId-${DateTime.now().millisecondsSinceEpoch}';
      print("Uploading image: $fileName");

      await supabase.storage.from('post').upload(fileName, image);
      print("Image uploaded successfully");

      // Get public URL of the uploaded image
      final imageUrl = supabase.storage.from('post').getPublicUrl(fileName);
      print("Image URL: $imageUrl");

      return imageUrl;
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
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
                    onTap: _pickImage,
                    child: DottedBorder(
                      color: Colors.deepPurple, // Border color
                      strokeWidth: 2, // Border width
                      borderType: BorderType.RRect, // Rounded rectangle
                      radius: Radius.circular(12), // Border radius
                      dashPattern: [6, 3], // Dash and gap length
                      child: Card(
                        shadowColor: Colors.deepPurple,
                        child: Column(
                          children: [
                            SizedBox(width: 300),
                            SizedBox(height: 10),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.deepPurple[200],
                              backgroundImage:
                                  _image != null ? FileImage(_image!) : null,
                              child: _image == null
                                  ? const Icon(Icons.camera_alt,
                                      color: Colors.white, size: 40)
                                  : null,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Click here to upload',
                                style: TextStyle(
                                    color:
                                        const Color.fromRGBO(103, 58, 183, 1),
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
                                  borderSide:
                                      BorderSide(color: Colors.deepPurple))),
                        ),
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
      )),
    );
  }
}
