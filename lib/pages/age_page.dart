import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shake/shake.dart';
import 'package:vibration/vibration.dart';

import '../model/ActivityList.dart';
import 'life_page.dart'; // Import the LifePage class

class AgePage extends StatefulWidget {
  const AgePage({
    Key? key,
  }) : super(key: key);

  @override
  _AgePageState createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  int age = 0;
  late ShakeDetector detector;

  @override
  void initState() {
    super.initState();
    _loadAgeFromPrefs();
    _configureShakeDetection();
  }

  Future<void> _loadAgeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      age = prefs.getInt('age') ?? 0;
    });
  }

  Future<void> _incrementAge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    GameStatus gameStatus = Provider.of<GameStatus>(context, listen: false);
    int updatedAge = age + 1;
    await prefs.setInt('age', updatedAge);
    setState(() {
      age = updatedAge;
      gameStatus.updateHappiness(-10);
      gameStatus.updateHealth(-10);
    });
    if (age >= 80) {
      _resetAge();
    }
  }

  void _configureShakeDetection() {
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        _incrementAge();
        print('Shaked! Age increased.');
        Vibration.vibrate(duration: 1000);
      },
    );
    detector.startListening();
  }

  @override
  Widget build(BuildContext context) {
    var gameStatus = Provider.of<GameStatus>(context);
    gameStatus.loadHealthFromPrefs();
    gameStatus.loadHappyFromPrefs();
    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeSim'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.purple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Life Events',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Age: $age',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.work,
                      color: Colors.white,
                    ),
                  ),
                  title: Text('Got a new job'),
                  subtitle: Text('Software Engineer'),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.airplane_ticket,
                      color: Colors.white,
                    ),
                  ),
                  title: Text('Took a vacation'),
                  subtitle: Text('Destination: Hawaii'),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                  ),
                  title: Text('Fell in love'),
                  subtitle: Text('Partner: John'),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LifePage()),
                    );
                  },
                  child: const Text('Activities'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 100,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _incrementAge();
                      },
                      child: const Text('Age Up'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _resetAge();
                        gameStatus.resetAll();
                      },
                      child: const Text('New Game'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Health: ${gameStatus.health}'),
                  Text('Happiness: ${gameStatus.happiness}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _resetAge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('age');
    setState(() {
      age = 0;
    });
  }

  @override
  void dispose() {
    detector.stopListening(); // Stop listening for shakes
    super.dispose();
  }
}
