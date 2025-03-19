// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_final_fields

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staff_app/edit_password.dart';
import 'package:staff_app/login.dart';
import 'package:staff_app/main.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController _ucontroller = TextEditingController();
  String username = "";
  String usercontact = "";
  String useremail = "";
  String userpassword = "";
  String imageUrl = "";
  bool isLoading = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> updData(String column) async {
    try {
      String eid = supabase.auth.currentUser!.id;
      await supabase
          .from('tbl_staff')
          .update({column: _ucontroller.text}).eq('id', eid);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Edited")));
      fetchUser();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:$e")));
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    print(pickedFile);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _mediaupload();
    }
  }

  Future<void> _mediaupload() async {
    try {
      String userId = supabase.auth.currentUser!.id;
      String? photoUrl;
      if (_image != null) {
        photoUrl = await _uploadImage(_image!, userId);
      }
      if (photoUrl!.isNotEmpty) {
        await supabase.from("tbl_staff").update({
          'staff_photo': photoUrl,
        }).eq('id', userId);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Photo Added")));
      } else {
        print("Photo url is empty");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try Again")));
      }
    } catch (e) {
      print("Error:$e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:$e")));
    }
  }

  Future<String?> _uploadImage(File image, String userId) async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy-HH-mm-ss').format(now);
      final fileName = '$userId-$formattedDate';

      await supabase.storage.from('staff_profile').upload(fileName, image);

      // Get public URL of the uploaded image
      final imageUrl =
          supabase.storage.from('staff_profile').getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  Future<void> fetchUser() async {
    try {
      String userId = supabase.auth.currentUser!.id;
      final response =
          await supabase.from('tbl_staff').select().eq('id', userId).single();
      if (response.isNotEmpty) {
        setState(() {
          username = response['staff_name'];
          usercontact = response['staff_contact'];
          useremail = response['staff_email'];
          userpassword = response['staff_password'];
          imageUrl = response['staff_photo'];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text(
          'My profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color.fromARGB(97, 123, 56, 56),
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : NetworkImage(imageUrl),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple[300]),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, 'staff_name');
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.deepPurple[300],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.email_outlined,
                          color: Colors.deepPurple[300],
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(useremail,
                                style: TextStyle(color: Colors.grey)),
                            Divider(thickness: 1, color: Colors.grey),
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),
                        trailing: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Can't edit email")));
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.deepPurple[300],
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.contact_phone_outlined,
                            color: Colors.deepPurple[300]),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(usercontact,
                                style: TextStyle(color: Colors.grey)),
                            Divider(
                                thickness: 1,
                                color: Colors.grey), // Underline below the text
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),
                        trailing: GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, 'staff_contact');
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.deepPurple[300],
                          ),
                        ), // Removes extra padding
                      ),
                      ListTile(
                        leading: Icon(Icons.password_outlined,
                            color: Colors.deepPurple[
                                300]), // Leading icon for the username
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('************',
                                style: TextStyle(color: Colors.grey)),
                            Divider(
                                thickness: 1,
                                color: Colors.grey), // Underline below the text
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),
                        trailing: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPassword(),
                                ));
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.deepPurple[300],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 100, right: 100, top: 30),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await supabase.auth.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StaffLogin(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple[300],
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          icon: Icon(Icons.logout_sharp),
                          label: Text(
                            "Log out",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  void _showBottomSheet(BuildContext context, String column) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // This ensures the bottom sheet takes up as much space as needed
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextField
              TextFormField(
                controller: _ucontroller,
                decoration: InputDecoration(
                  labelText: 'Enter something',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Save Button
              ElevatedButton(
                onPressed: () {
                  updData(column);
                  print('Saved!');
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text('Save'),
              ),
              SizedBox(height: 10),
              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
