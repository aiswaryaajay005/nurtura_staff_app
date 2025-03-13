import 'package:flutter/material.dart';
import 'package:staff_app/main.dart';
import 'package:intl/intl.dart';
import 'package:staff_app/view_attendence.dart';

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

  Future<void> markAbsent(int childId) async {
    await supabase.from('tbl_childattendence').upsert({
      'child_id': childId,
      'attendence_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'attendence_status': 0,
    });
    setState(() {});
  }

  Future<void> checkIn(int childId) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final formattedTime = DateFormat('HH:mm:ss').format(now);

    final response = await supabase
        .from('tbl_childattendence')
        .select()
        .eq('child_id', childId)
        .eq('attendence_date', formattedDate);

    if (response.isNotEmpty) {
      await supabase.from('tbl_childattendence').update({
        'attendence_status': 1,
        'checkin_time': formattedTime,
      }).match({'child_id': childId, 'attendence_date': formattedDate});
    } else {
      await supabase.from('tbl_childattendence').insert({
        'child_id': childId,
        'attendence_date': formattedDate,
        'attendence_status': 1,
        'checkin_time': formattedTime,
      });
    }
    setState(() {});
  }

  Future<void> checkOut(int childId) async {
    final formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
    await supabase.from('tbl_childattendence').update({
      'checkout_time': formattedTime,
    }).match({
      'child_id': childId,
      'attendence_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Mark Attendance",
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
          child: ListView.builder(
            itemCount: childrens.length,
            itemBuilder: (context, index) {
              final child = childrens[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            child['child_photo'] ?? 'Not available'),
                      ),
                      SizedBox(width: 15),
                      Text(
                        child['child_name'] ?? 'Unknown',
                        style: TextStyle(fontSize: 20, fontFamily: 'Nunito'),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextButton(
                              onPressed: () => markAbsent(child['id']),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepPurple),
                              child: Text(
                                'Absent',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Nunito'),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 100,
                            child: TextButton(
                              onPressed: () => checkIn(child['id']),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepPurple),
                              child: Text(
                                'Check-In',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Nunito'),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 100,
                            child: TextButton(
                              onPressed: () => checkOut(child['id']),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepPurple),
                              child: Text(
                                'Check-Out',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Nunito'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StaffAttendanceView(),
              ));
        },
        child: Text("view"),
      ),
    );
  }
}
/*
 */
