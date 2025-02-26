import 'package:flutter/material.dart';
import 'package:staff_app/main.dart';

class AttendencePage extends StatefulWidget {
  const AttendencePage({super.key});

  @override
  State<AttendencePage> createState() => _AttendencePageState();
}

class _AttendencePageState extends State<AttendencePage> {
  List<Map<String, dynamic>> childrens = [];

  @override
  void initState() {
    super.initState();
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    try {
      final response = await supabase.from('tbl_child').select();
      if (response.isNotEmpty) {
        setState(() {
          childrens = response;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Mark Attendence",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
            )),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
          itemCount: childrens.length,
          itemBuilder: (context, index) {
            final child = childrens[index];

            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              tileColor: Colors.grey.shade200,
              leading: Column(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(child['child_photo'] ?? 'Not available'),
                  ),
                  Text(child['child_name'] ?? 'Unknown'),
                ],
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Absent',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Check-In',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Check-Out',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
