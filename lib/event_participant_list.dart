// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:staff_app/main.dart';

class EventParticipantList extends StatefulWidget {
  const EventParticipantList({super.key});

  @override
  State<EventParticipantList> createState() => _EventParticipantListState();
}

class _EventParticipantListState extends State<EventParticipantList> {
  List<Map<String, dynamic>> participantList = [];
  @override
  void initState() {
    super.initState();
    fetchParticipant();
  }

  String statusCheck(int? status) {
    if (status == null) {
      return "Unknown"; // or any default value
    }
    return status == 1 ? "Will participate" : "Will not participate";
  }

  Future<void> fetchParticipant() async {
    try {
      final response = await supabase
          .from("tbl_participate")
          .select("*, tbl_child(*), tbl_event(*)");
      //  .eq('participate_status', 1)

      setState(() {
        participantList = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Participation',
          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
        ),
        backgroundColor: Colors.deepPurple[500],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: participantList.length,
        itemBuilder: (context, index) {
          final participant = participantList[index];
          String status =
              statusCheck(participant['participate_status'] as int?);
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(participant['tbl_child']?['child_photo']),
            ),
            title: Text(participant['tbl_child']?['child_name']),
            subtitle: Text(status),
          );
        },
      ),
    );
  }
}
