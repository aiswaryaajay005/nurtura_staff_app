import 'package:flutter/material.dart';
import 'package:staff_app/main.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, dynamic>> scheduledetails = [];

  Future<void> fetchSchedule() async {
    try {
      String userId = supabase.auth.currentUser!.id;
      final response =
          await supabase.from('tbl_schedule').select().eq('staff_id', userId);
      if (response.isNotEmpty) {
        setState(() {
          scheduledetails = response;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updStatus(int eid) async {
    try {
      await supabase
          .from('tbl_schedule')
          .update({'schedule_status': 1}).eq('id', eid);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Updated !")));
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Schedule',
          style: TextStyle(
            fontFamily: 'Lato',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        child: ListView.builder(
          itemCount: scheduledetails.length,
          itemBuilder: (context, index) {
            final schedule = scheduledetails[index];
            return Card(
              shadowColor: Colors.deepPurple,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 20,
                  children: [
                    Text(
                      'Schedule',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lato',
                          color: Colors.deepPurple),
                    ),
                    Row(
                      children: [
                        Text(
                          'Task Description:',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontFamily: 'Lato',
                          ),
                        ),
                        Text(schedule['task_description']),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Schedule Date: ',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontFamily: 'Lato',
                          ),
                        ),
                        Text(schedule['assigned_date']),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Start Time: ',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        Text(schedule['start_time']),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'End Time: ',
                          style: TextStyle(
                              fontFamily: 'Lato', color: Colors.deepPurple),
                        ),
                        Text(schedule['end_time']),
                      ],
                    ),
                    schedule['schedule_status'] == 0
                        ? ElevatedButton(
                            onPressed: () {
                              int eid = schedule['id'];
                              updStatus(eid);
                            },
                            child: Text('Completed'))
                        : Container()
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
