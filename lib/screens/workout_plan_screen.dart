import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_plan.dart';
import '../services/firestore_service.dart';

class WorkoutPlanScreen extends StatefulWidget {
  final String userId;

  const WorkoutPlanScreen({required this.userId});

  @override
  _WorkoutPlanScreenState createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _workoutNameController = TextEditingController();
  final _exerciseControllers = <Map<String, TextEditingController>>[];
  DateTime? _targetDate;
  bool _isLoading = false;

  void _addExerciseField() {
    setState(() {
      _exerciseControllers.add({
        'name': TextEditingController(),
        'sets': TextEditingController(),
        'reps': TextEditingController(),
        'rest': TextEditingController(),
      });
    });
  }

  Future<void> _saveWorkoutPlan() async {
    if (_formKey.currentState!.validate() && _targetDate != null) {
      setState(() {
        _isLoading = true;
      });

      List<Exercise> exercises = _exerciseControllers.map((controller) {
        return Exercise(
          name: controller['name']!.text,
          sets: int.parse(controller['sets']!.text),
          reps: int.parse(controller['reps']!.text),
          rest: int.parse(controller['rest']!.text),
        );
      }).toList();

      WorkoutPlan plan = WorkoutPlan(
        name: _workoutNameController.text,
        exercises: exercises,
        targetDate: _targetDate!,
      );

      try {
        await FirestoreService().addWorkoutPlan(widget.userId, plan);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Workout Plan Saved Successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Saving Workout Plan: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create/Edit Workout Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Workout Name Input
                TextFormField(
                  controller: _workoutNameController,
                  decoration: InputDecoration(labelText: 'Workout Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a workout name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Add Exercise Button
                ElevatedButton(
                  onPressed: _addExerciseField,
                  child: Text('Add Exercise'),
                ),

                // Dynamic Exercise Fields
                for (var controller in _exerciseControllers)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: controller['name'],
                          decoration: InputDecoration(labelText: 'Exercise Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an exercise name';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller['sets'],
                                decoration: InputDecoration(labelText: 'Sets'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      int.tryParse(value) == null ||
                                      int.parse(value) <= 0) {
                                    return 'Enter a valid number of sets';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: controller['reps'],
                                decoration: InputDecoration(labelText: 'Reps'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      int.tryParse(value) == null ||
                                      int.parse(value) <= 0) {
                                    return 'Enter a valid number of reps';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: controller['rest'],
                                decoration: InputDecoration(labelText: 'Rest (seconds)'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      int.tryParse(value) == null ||
                                      int.parse(value) <= 0) {
                                    return 'Enter a valid rest time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 20),

                // Target Date Picker
                ElevatedButton(
                  onPressed: () async {
                    _targetDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    setState(() {});
                  },
                  child: Text(_targetDate == null
                      ? 'Pick Target Date'
                      : 'Change Target Date'),
                ),
                if (_targetDate != null)
                  Text('Selected Date: ${_targetDate!.toLocal()}'),

                SizedBox(height: 20),

                // Save Button
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _saveWorkoutPlan,
                    child: Text('Save Workout Plan'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
