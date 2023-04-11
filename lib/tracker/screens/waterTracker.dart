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

import '../../core/ColorConstants.dart';

class WaterTracker extends StatefulWidget {
  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  SharedPreferences? prefs;

   // SharedPreferences? prefs2;   hier werden SharedPreferences für den MaxWert erstellt

  late TextEditingController controller = TextEditingController();

  int _maxAmountOfWater = 2000;

  int _amountOfWater = 0;

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
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _amountOfWater = (prefs?.getInt('counter') ?? 0);
      _updateHeightPercentage();
    });
  }

  Future<void> _resetCounter() async {
    _amountOfWater = 0;
    await prefs?.setInt('counter', 0);
    setState(() {
      _updateHeightPercentage();
    });
  }

  void submit() {
    Navigator.of(context).pop();

    setState(() {
      _maxAmountOfWater = int.parse(controller.text);
      _updateHeightPercentage();
    });
  }

  Future<void> _incrementFluid() async {
    _amountOfWater += 100;
    await prefs?.setInt('counter', _amountOfWater);
    setState(() {
      _updateHeightPercentage();
    });
  }

  void _updateHeightPercentage() {
    if (_amountOfWater > _maxAmountOfWater) {
      _heightPercentages = [
        _maxHeightPercentage,
      ];
      _amountOfWater = _maxAmountOfWater;
    }
    _heightPercentages = [
      _minHeightPercentage -
          (_amountOfWater / _maxAmountOfWater) *
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
                    colors: [CupertinoColors.activeBlue],
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
                    onTap: () => _incrementFluid(),
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
                          '${((_amountOfWater / _maxAmountOfWater) * 100).round()} % ',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${(_amountOfWater - _maxAmountOfWater)} ml left',
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
                            child: Text("Ändere dein Ziel (Wasserbedarf/Tag)",
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
            title: Text("Wasserziel (im ml)",
                style: TextStyle(color: Colors.black)),
            content: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                FilteringTextInputFormatter.digitsOnly
              ],
              autofocus: true,
              decoration: InputDecoration(hintText: "Wie viele ml am Tag?"),
            ),
            actions: [TextButton(onPressed: submit, child: Text("Speichern"))],
          ));


}
