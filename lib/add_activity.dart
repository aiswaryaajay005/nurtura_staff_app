import 'package:flutter/material.dart';
import 'package:staff_app/main.dart';

class AddActivity extends StatefulWidget {
  final int childId;
  const AddActivity({super.key, required this.childId});

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _feelingscontroller = TextEditingController();

  Future<void> insertData() async {
    try {
      await supabase.from('tbl_activity').insert({
        'activity_date': _datecontroller.text,
        'feeling_details': _feelingscontroller.text,
        'nap_schedule': napScale,
        'playtime_activities': playScale,
        'learning_activities': learnScale,
        'child_id': widget.childId
      });

      _datecontroller.clear();
      _feelingscontroller.clear();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Inserted!")));
    } catch (e) {
      print("Error inserting event: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to insert data. Please try again:$e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  double playScale = 0;
  double napScale = 0;
  double learnScale = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: Text(
            'Add activity',
            style: TextStyle(color: Colors.white),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Activity date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    readOnly: true,
                    controller: _datecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Select Date',
                      prefixIcon:
                          Icon(Icons.calendar_today, color: Colors.deepPurple),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        setState(() {
                          _datecontroller.text = formattedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Feeling Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _feelingscontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "How's the child feeling today?",
                      prefixIcon: Icon(Icons.child_friendly_outlined,
                          color: Colors.deepPurple),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nap schedule',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.bedtime, color: Colors.deepPurple),
                      SizedBox(height: 10),
                      Expanded(
                        child: Slider(
                          value: napScale,
                          max: 10,
                          min: 0,
                          divisions: 10,
                          label: napScale.toString(),
                          onChanged: (value) {
                            setState(() {
                              napScale = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Play Time Activities',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.toys, color: Colors.deepPurple),
                      SizedBox(height: 10),
                      Expanded(
                        child: Slider(
                          value: playScale,
                          max: 10,
                          min: 0,
                          divisions: 10,
                          label: playScale.toString(),
                          onChanged: (value) {
                            setState(() {
                              playScale = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Learning Activities',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.deepPurple),
                      SizedBox(height: 10),
                      Expanded(
                        child: Slider(
                          value: learnScale,
                          max: 10,
                          min: 0,
                          divisions: 10,
                          label: learnScale.toString(),
                          onChanged: (value) {
                            setState(() {
                              learnScale = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                      ),
                      onPressed: () {
                        insertData();
                      },
                      child: const Text(
                        "Save Activity Details",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
