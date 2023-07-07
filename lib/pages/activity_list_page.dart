import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/ActivityList.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ActivityListPageState();
  }
}

class ActivityListPageState extends State<ActivityListPage> {
  final TextEditingController txtController = TextEditingController();

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Activity maitenance"),
        ),
        body: Center(
          child: Column(
            children: [
              activityForm(context, txtController),
              const Expanded(child: ActivityListWidget()),
            ],
          ),
        ));
  }

  Widget activityForm(
    BuildContext context,
    TextEditingController txtController,
  ) {
    var activity = Provider.of<ActivityList>(context);

    return Column(
      children: [
        TextField(controller: txtController),
        ElevatedButton(
          onPressed: () {
            if (txtController.text.isNotEmpty) {
              activity.addActivity(txtController.text, "");
              txtController.text = "";
            }
          },
          child: const Text("insert"),
        )
      ],
    );
  }

  Widget cookieList(BuildContext context) {
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
