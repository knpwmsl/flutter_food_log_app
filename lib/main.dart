import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jzfgqsenffusofccoknf.supabase.co/rest/v1/',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6Zmdxc2VuZmZ1c29mY2Nva25mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY5NDM5MTIsImV4cCI6MjA5MjUxOTkxMn0.p7WJqr3ka0Yz2ESC82qb6Ue8Djmw38ePjU_cvNuEuCE',
  );

  runApp(
    FlutterFoodLogApp(),
  );
}

class FlutterFoodLogApp extends StatefulWidget {
  const FlutterFoodLogApp({super.key});

  @override
  State<FlutterFoodLogApp> createState() => _FlutterFoodLogAppState();
}

class _FlutterFoodLogAppState extends State<FlutterFoodLogApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenUi(),
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
