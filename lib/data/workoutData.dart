import 'package:fitness_app/model/exercise.dart';
import 'package:flutter/cupertino.dart';

import '../model/workout.dart';

class WorkoutData extends ChangeNotifier{
  List<Workout> workoutList = [
    Workout(name: "Upper Body", exercises: [
      Exercise(
        name: "Curls",
        isCompleted: true,
        weight: "10",
        reps: "10",
        sets: "4",
      ),
    ]),
    Workout(name: "Lower Body", exercises: [
      Exercise(
        name: "Squads",
        isCompleted: false,
        weight: "10",
        reps: "10",
        sets: "4",
      ),
    ])
  ];

  int numberOfExercisesInWorkout(String workoutName){
    return getRelevantWorkout(workoutName).exercises.length;
  }

  List<Workout> getWorkoutList() {
    return workoutList;
  }

  void deleteWorkoutFromList(String workoutName){
    Workout deletedWorkout =  workoutList.firstWhere((workout) => workout.name == workoutName);
    workoutList.remove(deletedWorkout);

  }

  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise? exercise = getRelevantExercise(workoutName, exerciseName);

    exercise.isCompleted = !exercise.isCompleted;

    notifyListeners();
  }

  Workout getRelevantWorkout(String workoutName) {

    Workout? workout = workoutList.firstWhere((workout) => workout.name == workoutName);

    return workout;

  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    return workoutList
        .firstWhere((workout) => workout.name == workoutName)
        .exercises
        .firstWhere((exercise) => exercise.name == exerciseName);
  }
}
