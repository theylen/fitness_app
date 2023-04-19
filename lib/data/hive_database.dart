import '../model/workout.dart';

class HiveDatabase {

  List<String> convertObjectToWorkoutList(List<Workout> workouts){
    List<String> workoutList = [

    ];

    for(int i=0; i < workouts.length; i++){
      workoutList.add(workouts[i].name,);
    }

    return workoutList;
  } //todo weiter im Video bei 29:10

}