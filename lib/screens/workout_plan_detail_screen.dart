import 'package:flutter/material.dart';
import '../models/workout_plan.dart';

class WorkoutPlanDetailScreen extends StatelessWidget {
  final WorkoutPlan plan;

  const WorkoutPlanDetailScreen({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout Name: ${plan.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Target Date: ${plan.targetDate.toLocal()}',
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 20),
            Text(
              'Exercises:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: plan.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = plan.exercises[index];
                  return ListTile(
                    leading: Icon(Icons.fitness_center),
                    title: Text(exercise.name),
                    subtitle: Text(
                      'Sets: ${exercise.sets}, Reps: ${exercise.reps}, Rest: ${exercise.rest}s',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
