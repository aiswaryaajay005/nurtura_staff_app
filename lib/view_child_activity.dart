import 'package:flutter/material.dart';
import 'package:staff_app/edit_activity.dart';
import 'package:staff_app/main.dart';

class ViewChildActivity extends StatefulWidget {
  final int childid;
  const ViewChildActivity({super.key, required this.childid});

  @override
  State<ViewChildActivity> createState() => _ViewChildActivityState();
}

class _ViewChildActivityState extends State<ViewChildActivity> {
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
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text('View Activity',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : childactivity.isEmpty
              ? Center(child: Text("No activity available"))
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: childactivity.length,
                  itemBuilder: (context, index) {
                    final activity = childactivity[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                activity['activity_date'] ?? 'No Details',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text("Feeling details:",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato',
                                    color: Colors.deepPurple)),
                            Text(activity['feeling_details'] ?? 'No Details',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'Lato',
                                )),
                            SizedBox(height: 10),
                            Text("Nap details:",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato',
                                    color: Colors.deepPurple)),
                            Text(activity['nap_schedule'] ?? 'No Details',
                                style: TextStyle(fontSize: 14)),
                            SizedBox(height: 10),
                            Text("Playtime activities:",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato',
                                    color: Colors.deepPurple)),
                            Text(
                                activity['playtime_activities'] ?? 'No Details',
                                style: TextStyle(fontSize: 14)),
                            SizedBox(height: 10),
                            Text("Learning activities:",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato',
                                    color: Colors.deepPurple)),
                            Text(
                                activity['learning_activities'] ?? 'No Details',
                                style: TextStyle(fontSize: 14)),
                            Spacer(),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditActivity(activityData: activity),
                                    ),
                                  );
                                },
                                child: Text("Edit",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
