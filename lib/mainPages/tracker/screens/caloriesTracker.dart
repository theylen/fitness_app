import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';

import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../../core/ColorConstants.dart';

class CaloriesTracker extends StatefulWidget {
  @override
  State<CaloriesTracker> createState() => _CaloriesTrackerState();
}

class _CaloriesTrackerState extends State<CaloriesTracker> {
  SharedPreferences? caloriesPrefs;

  // SharedPreferences? prefs2;   hier werden SharedPreferences für den MaxWert erstellt

  late TextEditingController controller = TextEditingController();

  int _maxAmountOfCalories = 2000;

  int _amountOfCalories = 0;

  static const _durations = [
    4000,
  ];

  List<double> _heightPercentages = [0.7];
  final double _minHeightPercentage = 0.8;
  final double _maxHeightPercentage = 0.01;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCounter();
    });
    super.initState();
  }

  _loadCounter() async {
    caloriesPrefs = await SharedPreferences.getInstance();
    setState(() {
      _amountOfCalories = (caloriesPrefs?.getInt('CaloriesCounter') ?? 0);
      _updateHeightPercentage();
    });
  }

  Future<void> _resetCounter() async {
    _amountOfCalories = 0;
    await caloriesPrefs?.setInt('CaloriesCounter', 0);
    setState(() {
      _updateHeightPercentage();
    });
  }

  void submit() {
    Navigator.of(context).pop();

    setState(() {
      _maxAmountOfCalories = int.parse(controller.text);
      _updateHeightPercentage();
    });
  }

  Future<void> _incrementCalories() async {
    _amountOfCalories += 100;
    await caloriesPrefs?.setInt('CaloriesCounter', _amountOfCalories);
    setState(() {
      _updateHeightPercentage();
    });
  }

  void _updateHeightPercentage() {
    if (_amountOfCalories > _maxAmountOfCalories) {
      _heightPercentages = [
        _maxHeightPercentage,
      ];
      _amountOfCalories = _maxAmountOfCalories;
    }
    _heightPercentages = [
      _minHeightPercentage -
          (_amountOfCalories / _maxAmountOfCalories) *
              (_minHeightPercentage - _maxHeightPercentage)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(children: [
          Expanded(
            flex: 10,
            child: Container(),
          ),
          Expanded(
            flex: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                WaveWidget(
                  config: CustomConfig(
                    colors: [Colors.brown],
                    durations: _durations,
                    heightPercentages: _heightPercentages,
                  ),
                  backgroundColor: Colors.transparent,
                  size: const Size(double.infinity, double.infinity),
                  waveAmplitude: 0,
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.60,
                  child: GestureDetector(
                    onTap: () => _incrementCalories(),
                    onLongPress: _resetCounter,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: Icon(
                        Icons.add,
                        color: ColorConstants.primaryColor.color,
                        size: 35,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.10,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
                    child: Column(
                      children: [
                        Text(
                          '${((_amountOfCalories / _maxAmountOfCalories) * 100).round()} % ',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${(_amountOfCalories - _maxAmountOfCalories)} kcal left',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  width: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.purple]),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: () => openDialog(),
                            child: Text("Ändere dein Ziel (kcal/Tag)",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    decoration: TextDecoration.none
                                )),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Wie viele kacl am Tag?",
            style: TextStyle(color: Colors.black)),
        content: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
            FilteringTextInputFormatter.digitsOnly
          ],
          autofocus: true,
          decoration: InputDecoration(hintText: "Wie viele kcal am Tag?"),
        ),
        actions: [TextButton(onPressed: submit, child: Text("Speichern"))],
      ));


}
