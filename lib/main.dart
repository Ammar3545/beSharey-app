import 'package:flutter/material.dart';
import 'package:share_app/first_screen.dart';

void main() => runApp(Home());


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        ),
      title: 'beSharey',
      home: FirstScreen(),
    );
  }
}