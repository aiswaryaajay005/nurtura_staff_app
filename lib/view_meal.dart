import 'package:flutter/material.dart';
import 'package:staff_app/main.dart';

class ViewMeal extends StatefulWidget {
  const ViewMeal({super.key});

  @override
  State<ViewMeal> createState() => _ViewMealState();
}

class _ViewMealState extends State<ViewMeal> {
  List<Map<String, dynamic>> meallist = [];
  @override
  void initState() {
    super.initState();
    fetchmeal();
  }

  Future<void> fetchmeal() async {
    try {
      final response = await supabase.from("tbl_mealmanagement").select();

      setState(() {
        meallist = response;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Meal details"),
      ),
      body: ListView.builder(
        itemCount: meallist.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Text("Meal Day :" + meallist[index]['meal_day']),
                Text('Description :' + meallist[index]['meal_description'])
              ],
            ),
          );
        },
      ),
    );
  }
}
