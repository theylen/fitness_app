import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {

  final String exerciseName;
  final String weight;
  final String sets;
  final String reps;
  final bool isCompleted;


  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({super.key, required this.exerciseName, required this.weight, required this.sets, required this.reps, required this.isCompleted, required this.onCheckBoxChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(13)),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(left: 300, right: 300, top: 30),
      child: ListTile(
        title: Text(exerciseName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        subtitle: Row(
          children: [
            Chip(
                label: Text(
                    weight + " kg")),
            Chip(
                label: Text(reps + " Wiederholungen")),
            Chip(
                label: Text(sets + " Sätze"))
          ],

        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckBoxChanged!(value),
        ),
      ),
    );
  }


}








