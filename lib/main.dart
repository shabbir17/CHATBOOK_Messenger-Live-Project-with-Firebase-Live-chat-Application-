import 'package:chatbook/chatbook_page.dart';
import 'package:chatbook/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
              bodyText2: TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
      home: const WelcomePage(),
    );
  }
}
