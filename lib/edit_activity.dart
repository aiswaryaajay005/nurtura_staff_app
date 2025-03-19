import 'package:flutter/material.dart';
import 'package:staff_app/main.dart';

class EditActivity extends StatefulWidget {
  final Map<String, dynamic> activityData;
  const EditActivity({super.key, required this.activityData});

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _feelingController;
  late TextEditingController _napController;
  late TextEditingController _playController;
  late TextEditingController _learnController;

  @override
  void initState() {
    super.initState();
    _feelingController =
        TextEditingController(text: widget.activityData['feeling_details']);
    _napController =
        TextEditingController(text: widget.activityData['nap_schedule']);
    _playController =
        TextEditingController(text: widget.activityData['playtime_activities']);
    _learnController =
        TextEditingController(text: widget.activityData['learning_activities']);
  }

  Future<void> updateActivity() async {
    await supabase.from('tbl_activity').update({
      'feeling_details': _feelingController.text,
      'nap_schedule': _napController.text,
      'playtime_activities': _playController.text,
      'learning_activities': _learnController.text,
    }).eq('id', widget.activityData['id']);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Activity")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _feelingController,
                  decoration: InputDecoration(labelText: "Feeling Details")),
              TextFormField(
                  controller: _napController,
                  decoration: InputDecoration(labelText: "Nap Details")),
              TextFormField(
                  controller: _playController,
                  decoration:
                      InputDecoration(labelText: "Playtime Activities")),
              TextFormField(
                  controller: _learnController,
                  decoration:
                      InputDecoration(labelText: "Learning Activities")),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: updateActivity, child: Text("Save Changes"))
            ],
          ),
        ),
      ),
    );
  }
}
