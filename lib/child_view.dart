import 'package:flutter/material.dart';
import 'package:staff_app/add_activity.dart';
import 'package:staff_app/main.dart';
import 'package:staff_app/view_child_activity.dart';
import 'package:staff_app/viewchild.dart';

class ChildView extends StatefulWidget {
  const ChildView({super.key});

  @override
  State<ChildView> createState() => _ChildViewState();
}

class _ChildViewState extends State<ChildView> {
  List<Map<String, dynamic>> childdetails = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchChild();
  }

  Future<void> fetchChild() async {
    try {
      String userId = supabase.auth.currentUser!.id;
      final response = await supabase.from('tbl_child').select();
      if (response.isNotEmpty) {
        setState(() {
          childdetails = response;
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
          backgroundColor: Colors.deepPurple[200],
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
              return Divider();
            },
            itemCount: childdetails.length,
            itemBuilder: (context, index) {
              final child = childdetails[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewChildDetails(
                          childid: child['id'],
                        ),
                      ));
                },
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  tileColor: Colors.deepPurple.shade100,
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(child['child_photo'] ?? 'Not available'),
                  ),
                  title: Text(child['child_name']),
                ),
              );
            },
          ),
        ));
  }
}
