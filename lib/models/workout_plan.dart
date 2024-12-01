class WorkoutPlan {
  String? id; // Firestore document ID
  String? planId; // Optional
  String name;
  List<Exercise> exercises;
  DateTime targetDate;
  bool completed;
  DateTime? createdAt; // Optional
  DateTime? updatedAt; // Optional


  WorkoutPlan({
    this.id,
    this.planId,
    required this.name,
    required this.exercises,
    required this.targetDate,
    this.completed = false,
    this.createdAt,
    this.updatedAt,
  });

  // Convert object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'name': name,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'targetDate': targetDate.toIso8601String(),
      'completed': completed,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Convert JSON from Firestore to object
  factory WorkoutPlan.fromJson(Map<String, dynamic> json, String id) {
    return WorkoutPlan(
      id: id,
      planId: json['planId'],
      name: json['name'],
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
      targetDate: DateTime.parse(json['targetDate']),
      completed: json['completed'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}

class Exercise {
  String name;
  int sets;
  int reps;
  int rest;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.rest,
  });

  // Convert object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'rest': rest,
    };
  }

  // Convert JSON from Firestore to object
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      rest: json['rest'],
    );
  }
}
