import 'package:fitness_app/mainPages/tracker/screens/waterTracker.dart';
import 'package:flutter/material.dart';

class TrackerOverview extends StatefulWidget {
  const TrackerOverview({Key? key}) : super(key: key);

  @override
  State<TrackerOverview> createState() => _TrackerOverviewState();
}

class _TrackerOverviewState extends State<TrackerOverview> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Container(
                height: size.height * .45,
                decoration: BoxDecoration(
                  color: Colors.black26,

                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('/images/body.png'),
                    scale: 0.7
                  ),
                ),

              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 52,
                    width: 52,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50),
                    child: Text(
                      "Guten morgen\n- jetzt lostracken",
                      style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    ),
                  ),
                ],
              ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 150,),
                            ToTrackerButton("Wassertracker"),
                            SizedBox(height: 30,),
                            ToTrackerButton("Kalorientracker")
                          ],
                      )

                    ],
                  ),
                ),
              ]),
        ),
        ),
    );

  }
}

class ToTrackerButton extends StatelessWidget {

  String _name;


  ToTrackerButton(this._name);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WaterTracker()),
        );
      },
      child: Container(
        height: 150,
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(_name, style: TextStyle(fontSize: 25, color: Colors.white), ),
            Icon(Icons.keyboard_arrow_right_outlined, size: 50, color: Colors.white,)
          ],
        )

      ),
    );

  }
}
