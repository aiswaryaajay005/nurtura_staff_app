import 'package:flutter/material.dart';
import 'package:staff_app/login.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://gflbqmzjujxsdbidtyhk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdmbGJxbXpqdWp4c2RiaWR0eWhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0NDc1MzUsImV4cCI6MjA1MzAyMzUzNX0.Zo7c3j74r5YTwhvwoaE0ukuWs87JyZtWyuVTtn8KTwI',
  );
  runApp(MainApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: StaffLogin());
  }
}
