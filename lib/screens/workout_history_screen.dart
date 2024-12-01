import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart'; // Import AuthService
import '../models/workout_plan.dart';
import 'workout_plan_screen.dart'; // Import the WorkoutPlanScreen
import 'workout_plan_detail_screen.dart'; // Import the detailed screen
import 'login_screen.dart'; // Import the LoginScreen for navigation

class WorkoutHistoryScreen extends StatefulWidget {
  final String userId;

  const WorkoutHistoryScreen({required this.userId});

  @override
  _WorkoutHistoryScreenState createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  List<WorkoutPlan> _workoutPlans = [];
  bool _isLoading = true;
  String _sortOption = 'Date';

  @override
  void initState() {
    super.initState();
    print('User ID: ${widget.userId}');
    _fetchWorkoutPlans();
  }

  Future<void> _fetchWorkoutPlans() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<WorkoutPlan> plans =
      await FirestoreService().fetchWorkoutPlans(widget.userId);
      setState(() {
        _workoutPlans = plans;
        _sortPlans(); // Apply default sorting
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching workout plans: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sortPlans() {
    if (_sortOption == 'Name') {
      _workoutPlans.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortOption == 'Date') {
      _workoutPlans.sort((a, b) => a.targetDate.compareTo(b.targetDate));
    }
    // Add additional sorting options if needed
  }

  void _navigateToAddPlan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPlanScreen(userId: widget.userId),
      ),
    ).then((value) {
      // Refresh the workout plans list after returning from the plan creation screen
      _fetchWorkoutPlans();
    });
  }

  // Logout function
  Future<void> _logout() async {
    try {
      await AuthService().logout();
      // Navigate back to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false, // Remove all previous routes
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Overview'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortOption = value;
                _sortPlans(); // Reapply sorting when selection changes
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Date', child: Text('Sort by Date')),
              PopupMenuItem(value: 'Name', child: Text('Sort by Name')),
              // Add more sorting options if needed
            ],
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _workoutPlans.isEmpty
          ? Center(child: Text('No workout plans found.'))
          : RefreshIndicator(
        onRefresh: _fetchWorkoutPlans,
        child: ListView.builder(
          itemCount: _workoutPlans.length,
          itemBuilder: (context, index) {
            WorkoutPlan plan = _workoutPlans[index];
            bool isUpcoming = plan.targetDate.isAfter(DateTime.now());

            return Card(
              margin:
              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(plan.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${plan.targetDate.toLocal()}'),
                    Text(isUpcoming ? 'Upcoming' : 'Completed'),
                  ],
                ),
                trailing: Icon(
                  isUpcoming ? Icons.upcoming : Icons.check_circle,
                  color: isUpcoming ? Colors.blue : Colors.green,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WorkoutPlanDetailScreen(plan: plan),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPlan,
        child: Icon(Icons.add),
        tooltip: 'Add New Plan',
      ),
    );
  }
}
