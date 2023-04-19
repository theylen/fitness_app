import 'package:fitness_app/data/workoutData.dart';
import 'package:fitness_app/mainPages/tracker/screens/workoutPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class FitnessTracker extends StatefulWidget {
  const FitnessTracker({Key? key}) : super(key: key);

  @override
  State<FitnessTracker> createState() => _FitnessTrackerState();
}

class _FitnessTrackerState extends State<FitnessTracker> {
  final newWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Erstelle ein neues Workout"),
              content: TextField(
                controller: newWorkoutNameController,
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: Text("speichern"),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: Text("abbrechen"),
                )
              ],
            ));
  }

  void save() {
    Provider.of<WorkoutData>(context, listen: false)
        .addWorkout(newWorkoutNameController.text);

    Navigator.pop(context);
    newWorkoutNameController.clear();
  }

  void cancel() {
    Navigator.pop(context);
    newWorkoutNameController.clear();
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutPage(
                  workoutName: workoutName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.black54,
            floatingActionButton: FloatingActionButton(
              onPressed: createNewWorkout,
              child: Icon(Icons.add),
            ),
            body: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.4, left: MediaQuery.of(context).size.width*0.2, right:MediaQuery.of(context).size.width*0.2 ),
                  child: ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: value.getWorkoutList().length,
                    itemBuilder: (BuildContext context, int index) => Slidable(
                      key: UniqueKey(),
                      endActionPane: ActionPane(
                        //dismissible: DismissiblePane(onDismissed: () {},),
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                              borderRadius: BorderRadius.circular(20),
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                              onPressed: (context) => {
                              setState(() {
                                value.deleteWorkoutFromList(value.getWorkoutList()[index].name);
                              })

                          },
                          )],
                      ),
                      //endActionPane: ,
                      child: ListTile(
                        tileColor: Colors.black54,
                        onTap: () =>
                            goToWorkoutPage(value.getWorkoutList()[index].name),
                        visualDensity: VisualDensity(vertical: 3),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(value.getWorkoutList()[index].name,
                            style: TextStyle(color: Colors.white)),
                        trailing:
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                ),
                Container(
                    margin: EdgeInsets.only(left: 50, top: 52),
                    child: Text(
                  "Create your\nworkout",
                  style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70),
                )),
              ],
            )),
      ),
    );
  }
}
