import 'package:flutter/material.dart';
import 'package:staff_app/main.dart';

class ViewLeaveDetails extends StatefulWidget {
  const ViewLeaveDetails({super.key});

  @override
  State<ViewLeaveDetails> createState() => _ViewLeaveDetailsState();
}

class _ViewLeaveDetailsState extends State<ViewLeaveDetails> {
  List<Map<String, dynamic>> leaveList = [];
  Future<void> viewLeave() async {
    try {
      final response =
          await supabase.from('tbl_childleave').select("*,tbl_child(*)");

      if (response.isNotEmpty) {
        setState(() {
          leaveList = response;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    viewLeave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Leave Notifications",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: leaveList.length,
            itemBuilder: (context, index) {
              final leaveView = leaveList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(leaveView['tbl_child']?['child_photo']),
                ),
                title: Text(
                    "Child Name: " + leaveView['tbl_child']?['child_name']),
                subtitle: Text("Leave Reason: " + leaveView['leave_reason']),
                trailing: Text("Leave Date: " + leaveView['leave_fordate']),
              );
            },
          ),
        ],
      ),
    );
  }
}
