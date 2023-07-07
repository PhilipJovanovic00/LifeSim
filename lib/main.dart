import 'package:flutter/material.dart';
import 'package:live_life_sim/pages/age_page.dart';
import 'package:provider/provider.dart';
import '../model/ActivityList.dart';
import '../pages/life_page.dart';

void main() {
  ActivityList activity = ActivityList();

  runApp(LifeSim(activity));
}

class LifeSim extends StatelessWidget {
  final ActivityList acticity;

  const LifeSim(this.acticity, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => acticity,
      child: ChangeNotifierProvider(
        create: (_) => GameStatus(),
        child: MaterialApp(
          title: 'Test of the day',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const AgePage(),
        ),
      ),
    );
  }
}
