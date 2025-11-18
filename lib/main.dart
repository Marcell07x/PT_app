import 'package:flutter/material.dart';
import 'questionaire.dart';
import 'button_status.dart';
import 'streak.dart';
import 'question1.dart';
import 'workout_flow.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StatusManager.loadStatus();
  await StreakManager.init(); 
  await prefsInit();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  // The SharedPreferences and counter logic is moved to MyHomePage
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(), // Use a separate widget for the home screen
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    
  }

  Future<void> _handleComplete() async {
    await StreakManager.incrementStreak();  // ← Using StreakManager instead
    await StatusManager.resetStatus();
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${StreakManager.streak}'),
        ),
      
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: //StatusManager.status == StatusManager.getTodayDate() 
                      //? null 
                      //: 
                      () async {
                          await StatusManager.resetStatus();
                          setState(() {});
                        }, 
                child: const Text('Ma Nem Edzek')),
               ElevatedButton(
                onPressed: //StatusManager.status == StatusManager.getTodayDate() 
                      //? null 
                      //: 
                      () async {
                  _handleComplete();
                  await StatusManager.resetStatus();
                  setState(() {});
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WorkoutFlow(),
                    ),
                  );
                },  
                child: const Text('Kész')),
               TextButton(onPressed: () {
           
                   Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Question1Page(),
                        ),
                      );
                },
                child: Text('Ez az űrlap képernyője.')),
                 
            ],
          )
        )
      );
    
    
  }


}
