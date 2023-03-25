import 'package:flutter/material.dart';
import 'package:smartvoting/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voting',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
          ),
        ),
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      home: const Home(),
    );
  }
}
