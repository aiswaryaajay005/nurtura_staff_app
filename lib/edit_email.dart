import 'package:flutter/material.dart';
import 'package:staff_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({super.key});

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  TextEditingController _oldcontroller = TextEditingController();
  TextEditingController _newcontroller = TextEditingController();
  TextEditingController _recontroller = TextEditingController();
  Future<void> changeEmail() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User is not logged in.")));
      return;
    }

    if (_newcontroller.text != _recontroller.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Passwords do not match.")));
      return;
    }

    if (_newcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password cannot be empty.")));
      return;
    }

    try {
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
          email: _newcontroller.text,
        ),
      );
      final User? updatedUser = res.user;

      final staffResponse = await supabase.from('tbl_staff').update({
        'staff_email': _newcontroller.text,
      }).eq('id', user.id);
      if (res.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Email changed successfully!")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to change email.")));
      }
      _newcontroller.clear();
      _oldcontroller.clear();
      _recontroller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Edit Email',
              style: TextStyle(color: Colors.deepPurple, fontSize: 30)),
          SizedBox(height: 20),
          Text(
            'Current Email',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _oldcontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Enter Current Email',
              prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'New Email',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _newcontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Enter New Email',
              prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Repeat New Email',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _recontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Repeat the new email',
              prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple[300],
            ),
            onPressed: () {
              changeEmail();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Change Email',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ])),
      ),
    );
  }
}
