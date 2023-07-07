import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'activity.dart';

class ActivityList extends ChangeNotifier {
  // Fake data, better use service
  final List<Activity> _activity = [
    Activity("training", "health"),
    Activity("run", "health"),
    Activity("meditate", "health"),
    Activity('cook', 'health'),
    Activity("work", 'Finance'),
    Activity('travel', 'health'),
  ];

  List<Activity> getActivityList() {
    return _activity;
  }

  void addActivity(String action, String category) {
    _activity.add(Activity(action, category));
    notifyListeners();
  }

  Activity getRandomActivity() {
    if (_activity.isEmpty) return Activity("No activity today", "");

    return _activity[Random().nextInt(_activity.length)];
  }
}

class ActivityListWidget extends StatelessWidget {
  const ActivityListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var activity = Provider.of<ActivityList>(context);

    return Card(
      child: ListView.builder(
        itemCount: activity.getActivityList().length,
        itemBuilder: (context, index) => ListTile(
          title: Text(activity.getActivityList()[index].action),
        ),
      ),
    );
  }
}

class ActivityListView with ChangeNotifier {
  final List<Activity> _activities = [];

  List<Activity> get activities => _activities;

  // Add this method to get the list of activities
  List<Activity> getActivityList() {
    return List.from(_activities);
  }

  // ...
}

class GameStatus extends ChangeNotifier {
  int _health = 100;
  int _happiness = 100;

  int get health => _health;
  int get happiness => _happiness;

  Future<void> updateHealth(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _health += value;
    await prefs.setInt('health', _health);
    notifyListeners();
  }

  Future<void> loadHealthFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _health = prefs.getInt('health') ?? 100;
    notifyListeners();
  }

  void updateHappiness(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _happiness += value;
    await prefs.setInt('happiness', _happiness);
    notifyListeners();
  }

  Future<void> loadHappyFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _happiness = prefs.getInt('happiness') ?? 100;
    notifyListeners();
  }

  void resetAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('health');
    prefs.remove('happiness');
    notifyListeners();
  }
}
