import 'package:flutter/material.dart';
import 'package:staff_app/attendence.dart';
import 'package:staff_app/child_view.dart';
import 'package:staff_app/event_participant_list.dart';

import 'package:staff_app/media.dart';
import 'package:staff_app/schedule.dart';
import 'package:staff_app/staffprofile.dart';
import 'package:staff_app/view_events.dart';
import 'package:staff_app/view_leave_details.dart';
import 'package:staff_app/view_post.dart';
import 'package:staff_app/viewchild.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              GridView(
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
                      onTap: () {},
                      child: Card(
                        color: Colors.white,
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
                  ]),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      hintText: 'Search',
                      suffixIcon: Icon(Icons.search, color: Colors.deepPurple),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.deepPurple))),
                ),
              ),
              // ListView(
              //   shrinkWrap: true,
              //   children: [
              //     ListTile(
              //       leading: CircleAvatar(
              //         backgroundImage: NetworkImage(
              //             'https://th.bing.com/th/id/OIP.JE2bVytitM8W0vzhYQRQaQHaEK?rs=1&pid=ImgDetMain'),
              //       ),
              //       title: Text("Anon"),
              //     ),
              //     ListTile(
              //       leading: CircleAvatar(
              //         backgroundImage: NetworkImage(
              //             'https://th.bing.com/th/id/OIP.JE2bVytitM8W0vzhYQRQaQHaEK?rs=1&pid=ImgDetMain'),
              //       ),
              //       title: Text("Joe"),
              //     ),
              //     ListTile(
              //       leading: CircleAvatar(
              //         backgroundImage: NetworkImage(
              //             'https://th.bing.com/th/id/OIP.JE2bVytitM8W0vzhYQRQaQHaEK?rs=1&pid=ImgDetMain'),
              //       ),
              //       title: Text("Roman"),
              //     ),
              //     ListTile(
              //       leading: CircleAvatar(
              //         backgroundImage: NetworkImage(
              //             'https://th.bing.com/th/id/OIP.JE2bVytitM8W0vzhYQRQaQHaEK?rs=1&pid=ImgDetMain'),
              //       ),
              //       title: Text("Miya"),
              //     ),
              //     ListTile(
              //       leading: CircleAvatar(
              //         backgroundImage: NetworkImage(
              //             'https://th.bing.com/th/id/OIP.JE2bVytitM8W0vzhYQRQaQHaEK?rs=1&pid=ImgDetMain'),
              //       ),
              //       title: Text("Nimy"),
              //     ),
              //     ListTile(
              //       leading: CircleAvatar(
              //         backgroundImage: NetworkImage(
              //             'https://th.bing.com/th/id/OIP.JE2bVytitM8W0vzhYQRQaQHaEK?rs=1&pid=ImgDetMain'),
              //       ),
              //       title: Text("Femi"),
              //     )
              //   ],
              // )
            ],
          ),
        ));
  }
}
