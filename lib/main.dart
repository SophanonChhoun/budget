import 'dart:async';
import 'package:budget/pages/page.dart';
import 'package:budget/repos/auth_repos.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/overview_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SecondScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/budget.png'),
          Image.network(
              "https://i.pinimg.com/originals/46/94/fd/4694fdf5de28b3084e511d886e208dc4.gif"),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final AuthRepo authRepo = AuthRepo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: authRepo.verifyExistingPin(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error loading app"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data ? Pin() : OverviewPage();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
