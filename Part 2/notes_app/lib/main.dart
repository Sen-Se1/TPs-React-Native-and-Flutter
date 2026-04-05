import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/notes_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  // Load environment variables before running the app
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/notes': (context) => const NotesScreen(),
      },
    );
  }
}