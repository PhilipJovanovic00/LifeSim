import 'package:uuid/uuid.dart';

// This class is used to store the activity data
class Activity {
  String id;
  final String action;
  final String category;

  Activity(this.action, this.category) : id = const Uuid().v4();
}
