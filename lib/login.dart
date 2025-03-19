// ignore_for_file: use_build_context_synchronously, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:staff_app/dashboard.dart';
import 'package:staff_app/form_validation.dart';
import 'package:staff_app/main.dart';
import 'package:staff_app/staff_registration.dart';

class StaffLogin extends StatefulWidget {
  const StaffLogin({super.key});

  @override
  State<StaffLogin> createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  Future<void> login() async {
    try {
      // Fetch staff status
      final response = await supabase
          .from('tbl_staff')
          .select('staff_status')
          .eq('staff_email', _emailcontroller.text)
          .single();

      int status = response['staff_status'];

      if (status == 0) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Application Under Review"),
                  content: Text(
                      "Your application is still under review. Please wait for approval."),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"))
                  ],
                ));
        return;
      } else if (status == 1) {
        await supabase.from('tbl_staff').update({'staff_status': 3}).eq(
            'staff_email', _emailcontroller.text);

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Congratulations!"),
                  content: Text(
                      "You have been selected. Your status has been updated."),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"))
                  ],
                ));
      } else if (status != 3) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You are not authorized to login.")));
        return;
      }

      await supabase.auth.signInWithPassword(
          password: _passwordcontroller.text, email: _emailcontroller.text);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => StaffDashboard(),
          ),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 100, right: 30, left: 30),
          children: [
            Image(
                image: AssetImage('assets/images/image.png'),
                height: 150,
                width: 150),
            Center(
              child: Text(
                "Nurtura",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'AmsterdamThree',
                  fontSize: 80,
                ),
              ),
            ),
            Text(
              "WELCOME BACK ",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                  fontFamily: 'Lato',
                  color: Colors.deepPurple[400]),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Nice to see you again.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Lato',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        validator: (value) =>
                            FormValidation.validateValue(value),
                        controller: _emailcontroller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'E-mail',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            hintText: 'example@gmail.com',
                            suffixIcon:
                                Icon(Icons.email, color: Colors.deepPurple),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        validator: (value) =>
                            FormValidation.validateValue(value),
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            hintText: 'Your password',
                            suffixIcon: Icon(Icons.visibility,
                                color: Colors.deepPurple),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[300],
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StaffRegistration(),
                            ),
                          );
                        },
                        child: Text(
                          'Create new account',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
