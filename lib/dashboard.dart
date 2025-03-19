import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:staff_app/attendence.dart';
import 'package:staff_app/child_view.dart';
import 'package:staff_app/event_participant_list.dart';

import 'package:confetti/confetti.dart';
import 'package:staff_app/inform_leave.dart';
import 'package:staff_app/main.dart';
import 'package:staff_app/schedule.dart';
import 'package:staff_app/staffprofile.dart';
import 'package:staff_app/view_events.dart';
import 'package:staff_app/view_leave_details.dart';
import 'package:staff_app/view_meal.dart';
import 'package:staff_app/view_post.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  final ConfettiController _confettiController =
      ConfettiController(duration: Duration(seconds: 5));

  Future<void> checkAndShowBirthdayDialogue(BuildContext context) async {
    List<Map<String, dynamic>> todaysBirthdays = await getTodaysBirthdays();

    if (todaysBirthdays.isNotEmpty) {
      String names =
          todaysBirthdays.map((child) => child['child_name']).join(', ');
      birthdayDialogue(context, names);
    }
  }

  Future<List<Map<String, dynamic>>> getTodaysBirthdays() async {
    String today = DateFormat('MM-dd').format(DateTime.now());

    try {
      final response = await supabase
          .from('tbl_child')
          .select('id, child_name, child_dob, child_photo');
      if (response.isEmpty) return [];

      List<Map<String, dynamic>> birthdayChildren = response.where((child) {
        String dob = child['child_dob'];
        return dob.substring(5) == today;
      }).toList();

      return birthdayChildren;
    } catch (e) {
      print("Error fetching birthdays: $e");
      return [];
    }
  }

  void birthdayDialogue(BuildContext context, String birthdayNames) {
    _confettiController.play();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.deepPurple.shade500,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "🎉 We have a birthday today! 🎂",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$birthdayNames is celebrating their birthday today! Let's make it special!",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _confettiController.stop();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Ok",
                          style: TextStyle(color: Colors.deepPurple)),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: [
                    Colors.white,
                    Colors.deepPurple,
                    Colors.red,
                    Colors.pink,
                    Colors.blue,
                    Colors.yellow,
                    Colors.green
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkAndShowBirthdayDialogue(context);

    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ));
            },
            child: CircleAvatar(
              foregroundImage: AssetImage('assets/images/staff.jpeg'),
            ),
          ),
          actions: [
            Text(
              "Nurtura",
              style: TextStyle(
                color: Colors.deepPurple,
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
        body: Column(
          children: [
            Expanded(
              child: GridView(
                  padding: EdgeInsets.all(20),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChildView(),
                            ));
                      },
                      child: Card(
                        color: Colors.deepPurple[100],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Icon(
                              Icons.group,
                              color: Colors.deepPurple,
                              size: 60,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Children',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SchedulePage(),
                            ));
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Icon(
                              Icons.schedule,
                              color: Colors.deepPurple,
                              size: 60,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Schedule',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPost(),
                            ));
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Icon(
                              Icons.camera,
                              color: Colors.deepPurple,
                              size: 60,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Media',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewEvents(),
                            ));
                      },
                      child: Card(
                        color: Colors.deepPurple[100],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Icon(
                              Icons.event,
                              color: Colors.deepPurple,
                              size: 60,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Events',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttendencePage(),
                            ));
                      },
                      child: Card(
                        color: Colors.deepPurple[100],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Icon(
                              Icons.check_box,
                              color: Colors.deepPurple,
                              size: 60,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Attendence',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventParticipantList(),
                            ));
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Icon(
                              Icons.list,
                              color: Colors.deepPurple,
                              size: 60,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Event Participants',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewLeaveDetails(),
                            ));
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Icon(
                              Icons.notification_important_outlined,
                              color: Colors.deepPurple,
                              size: 60,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Leave Notifications',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewMeal(),
                            ));
                      },
                      child: Card(
                        color: Colors.deepPurple[100],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Icon(
                              Icons.food_bank,
                              color: Colors.deepPurple,
                              size: 60,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Meal Details',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InformLeave(),
                            ));
                      },
                      child: Card(
                        color: Colors.deepPurple.shade100,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Icon(
                              Icons.sick,
                              color: Colors.deepPurple,
                              size: 60,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Inform Leave',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            SizedBox(height: 20)
          ],
        ));
  }
}
