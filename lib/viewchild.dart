import 'package:flutter/material.dart';
import 'package:staff_app/add_activity.dart';
import 'package:staff_app/main.dart';
import 'package:staff_app/view_child_activity.dart';

class ViewChildDetails extends StatefulWidget {
  final int childid;
  const ViewChildDetails({super.key, required this.childid});

  @override
  State<ViewChildDetails> createState() => _ViewChildDetailsState();
}

class _ViewChildDetailsState extends State<ViewChildDetails> {
  List<Map<String, dynamic>> childdetails = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchChild();
    fetchActivity();
  }

  List<Map<String, dynamic>> childactivity = [];
  bool isLoading = true;
  Future<void> fetchActivity() async {
    try {
      final response = await supabase
          .from('tbl_activity')
          .select()
          .eq('child_id', widget.childid);

      if (response.isNotEmpty) {
        setState(() {
          childactivity = response;
        });
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading after fetching data
      });
    }
  }

  Future<void> fetchChild() async {
    try {
      String userId = supabase.auth.currentUser!.id;
      final response =
          await supabase.from('tbl_child').select().eq('id', widget.childid);
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
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: childdetails.length,
            itemBuilder: (context, index) {
              final child = childdetails[index];
              return Card(
                shadowColor: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 20,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(child['child_photo'] ?? 'no profile'),
                      ),
                      Row(
                        children: [
                          Icon(Icons.child_care,
                              color: Colors.deepPurple, size: 40),
                          SizedBox(width: 5),
                          Text(
                            'Child Name:',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          Text(child['child_name']),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.girl, color: Colors.deepPurple, size: 40),
                          SizedBox(width: 5),
                          Text(
                            'Child Gender: ',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          Text(child['child_gender']),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.date_range,
                              color: Colors.deepPurple, size: 40),
                          SizedBox(width: 5),
                          Text(
                            'Date of Birth :',
                            style: TextStyle(
                              color: Colors.deepPurple,
                            ),
                          ),
                          Text(child['child_dob']),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.sick, color: Colors.deepPurple, size: 40),
                          SizedBox(width: 5),
                          Text(
                            'Child allergy details: ',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          Text(child['child_allergy']),
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddActivity(
                                    childId: child['id'],
                                  ),
                                ));
                          },
                          child: Text('Add Activity Details')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewChildActivity(
                                          childid: child['id'],
                                        )));
                          },
                          child: Text('View Activity Details'))
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
