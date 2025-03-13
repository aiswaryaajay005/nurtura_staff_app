import 'package:flutter/material.dart';
import 'package:staff_app/main.dart';
import 'package:intl/intl.dart';

class StaffAttendanceView extends StatefulWidget {
  const StaffAttendanceView({super.key});

  @override
  State<StaffAttendanceView> createState() => _StaffAttendanceViewState();
}

class _StaffAttendanceViewState extends State<StaffAttendanceView> {
  List<Map<String, dynamic>> attendanceRecords = [];
  List<Map<String, dynamic>> childrens = [];

  @override
  void initState() {
    super.initState();
    fetchChildrenAndAttendance();
  }

  Future<void> fetchChildrenAndAttendance() async {
    try {
      final childrenResponse = await supabase.from('tbl_child').select();
      final attendanceResponse = await supabase
          .from('tbl_childattendence')
          .select(
              'child_id, attendence_date, checkin_time, checkout_time, attendence_status')
          .order('attendence_date', ascending: false);

      if (childrenResponse.isNotEmpty) {
        setState(() {
          childrens = childrenResponse;
          attendanceRecords = attendanceResponse;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Child Attendance Records",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: childrens.length,
          itemBuilder: (context, index) {
            final child = childrens[index];
            final record = attendanceRecords.firstWhere(
              (att) => att['child_id'] == child['id'],
              orElse: () => {},
            );
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(child['child_photo']),
                  radius: 40,
                ),
                title: Text(child['child_name'] ?? 'Unknown'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Date: ${record.isNotEmpty ? record['attendence_date'] : 'Not Marked'}"),
                    Text(
                        "Check-In: ${record.isNotEmpty ? record['checkin_time'] ?? 'Not Checked In' : 'Not Marked'}"),
                    Text(
                        "Check-Out: ${record.isNotEmpty ? record['checkout_time'] ?? 'Not Checked Out' : 'Not Marked'}"),
                    Text(
                        "Status: ${record.isNotEmpty ? (record['attendence_status'] == 1 ? 'Present' : 'Absent') : 'Not Marked'}"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
