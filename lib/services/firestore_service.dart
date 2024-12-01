import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_plan.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new workout plan
  Future<void> addWorkoutPlan(String userId, WorkoutPlan plan) async {
    try {
      await _firestore
          .collection('workout_plans')
          .doc(userId)
          .collection('plans')
          .add(plan.toJson());
    } catch (e) {
      throw Exception("Error adding workout plan: $e");
    }
  }

  // Fetch all workout plans for a user
  Future<List<WorkoutPlan>> fetchWorkoutPlans(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('workout_plans')
          .doc(userId)
          .collection('plans')
          .get();

      return snapshot.docs.map((doc) {
        return WorkoutPlan.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception("Error fetching workout plans: $e");
    }
  }

  // Update a workout plan
  Future<void> updateWorkoutPlan(String userId, String planId, WorkoutPlan plan) async {
    try {
      await _firestore
          .collection('workout_plans')
          .doc(userId)
          .collection('plans')
          .doc(planId)
          .update(plan.toJson());
    } catch (e) {
      throw Exception("Error updating workout plan: $e");
    }
  }

  // Delete a workout plan
  Future<void> deleteWorkoutPlan(String userId, String planId) async {
    try {
      await _firestore
          .collection('workout_plans')
          .doc(userId)
          .collection('plans')
          .doc(planId)
          .delete();
    } catch (e) {
      throw Exception("Error deleting workout plan: $e");
    }
  }
}
