import 'package:flutter/material.dart';
import 'questionaire.dart';
import 'button_status.dart';
import 'streak.dart';
import 'question1.dart';
import 'workout_flow.dart';
import 'workouta_reps.dart';

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
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: MyHomePage(),
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
        await StreakManager.incrementStreak();
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
                            onPressed: () async {
                                await StatusManager.resetStatus();
                                setState(() {});
                            }, 
                            child: const Text('Ma Nem Edzek')
                        ),
                        ElevatedButton(
                            onPressed: () async {
                                _handleComplete();
                                await StatusManager.resetStatus();
                                setState(() {});
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => WorkoutFlow(),
                                    ),
                                );
                            },  
                            child: const Text('Kész')
                        ),
                        TextButton(
                            onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => Question1Page(),
                                    ),
                                );
                            },
                            child: Text('Ez az űrlap képernyője.')
                        ),
                    ],
                )
            )
        );
    }
}