import 'package:flutter/material.dart';
import 'workout_screen.dart';
import 'workout_done_screen.dart';

class WorkoutFlow extends StatefulWidget {
  @override
  _WorkoutFlowState createState() => _WorkoutFlowState();
}

class _WorkoutFlowState extends State<WorkoutFlow> {
  final List<Map<String, String>> _workouts = [
    {
      'videoPath': 'assets/videos/test1.mp4',
      'description': 'Guggolás - 4 sorozat, 10 ismétlés\nPihenő: 45 másodperc',
    },
    {
      'videoPath': 'assets/videos/test2.mp4',
      'description': 'Húzódzkodás - 3 sorozat, 8 ismétlés\nPihenő: 90 másodperc',
    },
  ];

  int _currentIndex = 0;

  void _goToNext() {
    if (_currentIndex < _workouts.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CongratulationsScreen()),
      );
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastWorkout = _currentIndex == _workouts.length - 1;
    
    return WorkoutScreen(
      videoPath: _workouts[_currentIndex]['videoPath']!,
      description: _workouts[_currentIndex]['description']!,
      buttonText: isLastWorkout ? 'Befejezés' : 'Következő',
      onNextPressed: _goToNext,
      onPreviousPressed: _goToPrevious,
      currentIndex: _currentIndex,
      totalWorkouts: _workouts.length,
    );
  }
}