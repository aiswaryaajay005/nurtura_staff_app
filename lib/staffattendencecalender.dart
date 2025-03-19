import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:staff_app/main.dart';

class StaffAttendanceCalendar extends StatefulWidget {
  const StaffAttendanceCalendar({super.key});

  @override
  State<StaffAttendanceCalendar> createState() =>
      _StaffAttendanceCalendarState();
}

class _StaffAttendanceCalendarState extends State<StaffAttendanceCalendar> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> attendanceRecords = [];
  List<Map<String, dynamic>> childrenResponse = [];

  @override
  void initState() {
    super.initState();
    fetchAttendanceRecords(_selectedDate);
  }

  Future<void> fetchAttendanceRecords(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      final children = await supabase.from('tbl_child').select();
      final response = await supabase
          .from('tbl_childattendence')
          .select('child_id, attendence_status, checkin_time, checkout_time')
          .eq('attendence_date', formattedDate);

      setState(() {
        attendanceRecords = response;
        childrenResponse = children;
      });
    } catch (e) {
      print("Error fetching attendance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Attendance Calendar",
          style: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
        ),
      ),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _selectedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                fetchAttendanceRecords(selectedDay);
              });
            },
          ),

          // Attendance List
          Expanded(
            child: attendanceRecords.isEmpty
                ? Center(
                    child: Text(
                      "No Attendance Data for Selected Date",
                      style: TextStyle(fontSize: 16, fontFamily: 'Nunito'),
                    ),
                  )
                : ListView.builder(
                    itemCount: attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final record = attendanceRecords[index];
                      final child = childrenResponse.firstWhere(
                          (c) => c['id'] == record['child_id'],
                          orElse: () => {});

                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(child['child_photo'] ?? ''),
                            radius: 30,
                          ),
                          title: Text(
                            child['child_name'] ?? 'Unknown',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Check-In: ${record['checkin_time'] ?? 'Not Checked In'}"),
                              Text(
                                  "Check-Out: ${record['checkout_time'] ?? 'Not Checked Out'}"),
                              Text(
                                "Status: ${record['attendence_status'] == 1 ? 'Present' : 'Absent'}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: record['attendence_status'] == 1
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
