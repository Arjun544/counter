import 'package:counter_challenge/counter_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CounterScreen(
        title: 'Counter Challenge',
        initialValue: 0,
        direction: Axis.vertical,
        onChanged: (int value) => print('new value $value'),
      ),
    );
  }
}
