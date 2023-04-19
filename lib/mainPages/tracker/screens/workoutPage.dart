import 'package:fitness_app/components/exerciseTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/workoutData.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({Key? key, required this.workoutName}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //Text Controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              backgroundColor: Colors.black54,
              title: Text("Neue exercise hinzufügen",
                style: TextStyle(color: Colors.white),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Exercise",
                        hintStyle: TextStyle(color: Colors.white54)
                    ),
                    controller: exerciseNameController,
                  ),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Gewicht (in kg)",
                        hintStyle: TextStyle(color: Colors.white54)
                    ),
                    controller: weightController,
                  ),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Reps",
                        hintStyle: TextStyle(color: Colors.white54)
                    ),
                    controller: repsController,
                  ),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Sätze",
                        hintStyle: TextStyle(color: Colors.white54)
                    ),
                    controller: setsController,
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: Text(
                    "speichern", style: TextStyle(color: Colors.white),),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: Text(
                    "abbrechen", style: TextStyle(color: Colors.white),),
                )
              ],
            ));
  }

  void save() {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;


    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(
        widget.workoutName,
        newExerciseName,
        weight,
        reps,
        sets
    );

    Navigator.pop(context);
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  void cancel() {
    Navigator.pop(context);
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  //todo weiter im Video bei 21:00
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) =>
          Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              title: Text(widget.workoutName),
              centerTitle: true,
              backgroundColor: Colors.black54,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: createNewExercise,
            ),
            body: ListView.builder(
              itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
              itemBuilder: (context, index) =>
                  ExerciseTile(
                    exerciseName: value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .name,
                    weight: value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .weight,
                    sets: value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .sets,
                    reps: value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .reps,
                    isCompleted:
                    value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index].isCompleted,
                    //todo hier noch igendwie einen funktionierenden Null Check einbauen
                    onCheckBoxChanged: (val)  => onCheckBoxChanged(
                  widget.workoutName,
                value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index].name,
              ),
            ),
          ),
    ),);
  }
}
