import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fitness_app/data/workoutData.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'mainPages/tracker/screens/fitnessTracker.dart';
import 'mainPages/trackerOverview.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox("workout_database");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _selectedIndex = 0;

  final _controller = PageController();

  List<Widget> screens = [
    TrackerOverview(),
    FitnessTracker(),
    //CaloriesTracker()
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 700 ,
                  child: PageView(
                    controller: _controller,
                    children: const [
                      TrackerOverview(),
                      FitnessTracker(),
                    ],
                  ),
                ),
                SmoothPageIndicator(
                    controller: _controller,
                    count: 2,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.blue,
                      dotColor: Colors.lightBlueAccent,
                      dotHeight: 20,
                      dotWidth: 20
                    ),
                ),
              ],
            )),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
