import 'package:flutter/material.dart';
import 'package:staff_app/form_validation.dart';
import 'package:staff_app/main.dart';

class InformLeave extends StatefulWidget {
  const InformLeave({super.key});

  @override
  State<InformLeave> createState() => _InformLeaveState();
}

class _InformLeaveState extends State<InformLeave> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  String _leaveType = "Full Day";

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> insertData() async {
    String userId = supabase.auth.currentUser!.id;
    try {
      await supabase.from('tbl_staffleave').insert({
        'leave_fordate': _dateController.text,
        'leave_reason': _reasonController.text,
        'leave_type': _leaveType,
        'staff_id': userId,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Inserted Successfully")));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: Text("Leave Details", style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Leave Date"),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) => FormValidation.validateDate(value),
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Select a date",
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.calendar_today),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 10),
              Text("Leave Type"),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _leaveType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: ["Full Day", "Half Day"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _leaveType = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              Text("Leave Reason"),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) => FormValidation.validateValue(value),
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Enter Reason",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.deepPurpleAccent
                      ], // Gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        insertData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Center(
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
