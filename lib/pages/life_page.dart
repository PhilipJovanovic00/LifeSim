import 'package:live_life_sim/model/ActivityList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'age_page.dart';

class LifePage extends StatefulWidget {
  LifePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LifePageState();
  }
}

class LifePageState extends State<LifePage> {
  @override
  Widget build(BuildContext context) {
    var activity = Provider.of<ActivityList>(context);
    var gameStatus = Provider.of<GameStatus>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity of the day"),
      ),
      body: GestureDetector(
        onTap: redrawActivity,
        child: Container(
          color: Colors.purple,
          child: Center(
            child: ListView.builder(
              itemCount: activity.getActivityList().length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (activity.getActivityList()[index].action ==
                        "training") {
                      gameStatus.updateHealth(10);
                    }
                    if (activity.getActivityList()[index].action == "travel") {
                      gameStatus.updateHappiness(10);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AgePage()),
                    );

                    // Handle activity click here
                    // You can perform any action when an activity is clicked
                    print(
                        'Activity clicked: ${activity.getActivityList()[index].action}');
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(activity.getActivityList()[index].action),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void redrawActivity() {
    setState(() {
      // Nothing to do, only redraw
    });
  }
}
