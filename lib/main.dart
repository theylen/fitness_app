import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fitness_app/tracker/screens/fitnessTracker.dart';
import 'package:fitness_app/tracker/screens/waterTracker.dart';
import 'package:flutter/material.dart';

import 'mainPages/trackerOverview.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _selectedIndex = 0;


  List<Widget> screens = [
      TrackerOverview(),
    //WaterTracker(),
      FitnessTracker(),
      //CaloriesTracker()
  ];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:  screens[_selectedIndex],
        backgroundColor: Colors.black,
        bottomNavigationBar: CurvedNavigationBar(
          items:
          <Widget>[
            Icon(Icons.water_drop_outlined, size: 40, color: Colors.black,),
            Icon(Icons.fitness_center_outlined, size: 40, color: Colors.black,),
            Icon(Icons.fastfood_outlined, size: 40, color: Colors.black,),
          ],
          onTap: (index) {
            _onItemTapped(index);
          },
          color: Colors.transparent,
          backgroundColor: Colors.grey,
          buttonBackgroundColor: Colors.white,
        ),


      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}


