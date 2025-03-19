import 'dart:io';
import 'package:flutter/material.dart';
import 'package:staff_app/form_validation.dart';
import 'package:staff_app/main.dart';
import 'package:file_picker/file_picker.dart';

class StaffRegistration extends StatefulWidget {
  const StaffRegistration({super.key});

  @override
  State<StaffRegistration> createState() => _StaffRegistrationState();
}

class _StaffRegistrationState extends State<StaffRegistration> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _contactcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _cpasswordcontroller = TextEditingController();
  TextEditingController _addresscontroller = TextEditingController();
  TextEditingController _cvcontroller = TextEditingController();

  InputDecoration customInputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.deepPurple),
    );
  }

  Future<void> register() async {
    try {
      final auth = await supabase.auth.signUp(
          password: _passwordcontroller.text, email: _emailcontroller.text);
      final uid = auth.user!.id;
      if (uid.isNotEmpty || uid != "") {
        storeData(uid);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> storeData(final uid) async {
    String? cvUrl = await uploadFile();
    try {
      await supabase.from("tbl_staff").insert({
        'id': uid,
        'staff_name': _namecontroller.text,
        'staff_email': _emailcontroller.text,
        'staff_contact': _contactcontroller.text,
        'staff_password': _passwordcontroller.text,
        'staff_address': _addresscontroller.text,
        'staff_cv': cvUrl,
      });
      _namecontroller.clear();
      _emailcontroller.clear();
      _contactcontroller.clear();
      _passwordcontroller.clear();
      _addresscontroller.clear();
      _cvcontroller.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Inserted!")));
    } catch (e) {
      print("Error storing data: $e");
    }
  }

  File? selectedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        _cvcontroller.text = result.files.single.name;
      });
    }
  }

  Future<String?> uploadFile() async {
    if (selectedFile == null) {
      return "";
    }

    try {
      final fileExt = selectedFile!.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      await supabase.storage.from('staffcv').upload(fileName, selectedFile!);
      final fileUrl = supabase.storage.from('staffcv').getPublicUrl(fileName);

      print("File Uploaded: $fileUrl");
      return fileUrl;
    } catch (e) {
      print("Upload Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File upload failed!")),
      );
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'New Registration',
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Montserrat-Regular',
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          validator: (value) =>
                              FormValidation.validateName(value),
                          controller: _namecontroller,
                          decoration:
                              customInputDecoration('Enter name', Icons.person),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          validator: (value) =>
                              FormValidation.validateEmail(value),
                          controller: _emailcontroller,
                          decoration:
                              customInputDecoration('Enter email', Icons.email),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          validator: (value) =>
                              FormValidation.validateContact(value),
                          controller: _contactcontroller,
                          decoration: customInputDecoration(
                              'Enter contact number', Icons.phone),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          validator: (value) =>
                              FormValidation.validateValue(value),
                          controller: _addresscontroller,
                          decoration: customInputDecoration(
                              'Enter Address', Icons.home),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          validator: (value) =>
                              FormValidation.validatePassword(value),
                          controller: _passwordcontroller,
                          decoration: customInputDecoration(
                              'Enter password', Icons.lock),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          validator: (value) =>
                              FormValidation.validatePassword(value),
                          controller: _cpasswordcontroller,
                          decoration: customInputDecoration(
                              'Confirm password', Icons.lock),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          onTap: pickFile,
                          child: AbsorbPointer(
                            child: TextFormField(
                              readOnly: true,
                              controller: _cvcontroller,
                              maxLines: 3,
                              decoration: customInputDecoration(
                                  'Click here to upload your CV',
                                  Icons.upload_file),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            register();
                          }
                        },
                        child: Text('Submit',
                            style: TextStyle(
                              fontFamily: 'Montserrat-Regular',
                            )),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
