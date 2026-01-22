import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'workout_done_screen.dart';

//if the level is under 150 this page should appear only once in every week

class WorkoutFeedback extends StatefulWidget {
    @override
    _WorkoutFeedbackState createState() => _WorkoutFeedbackState();
}

class _WorkoutFeedbackState extends State<WorkoutFeedback> {
    // if level > 150 this should be at 3 ftom the beginning
    double _rpeValue = 5.0;
    
    final List<String> _rpeDescriptions = [
        '1 - Semmi erőfeszítés',
        '2 - Nagyon könnyű',
        '3 - Könnyű',
        '4 - Mérsékelt',
        '5 - Egy kicsit nehéz',
        '6 - Nehéz',
        '7 - Nagyon nehéz',
        '8 - Rendkívül nehéz',
        '9 - Extrém',
        '10 - Maximális erőfeszítés'
    ];

    Color _getColorForRPE(double value) {
        if (value <= 3) return Colors.green;
        if (value <= 5) return Colors.lightGreen;
        if (value <= 7) return Colors.orange;
        return Colors.red;
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('Edzés Visszajelzés'),
            ),
            body: SafeArea(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                        children: [
                            Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Container(
                                            width: 250,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                color: _getColorForRPE(_rpeValue),
                                                borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                                children: [
                                                    Text(
                                                        'RPE: ${_rpeValue.round()}',
                                                        style: TextStyle(
                                                            fontSize: 32,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                        ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                        _rpeDescriptions[_rpeValue.round() - 1],
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                    ),
                                                ],
                                            ),
                                        ),
                                        SizedBox(height: 30),
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Column(
                                                children: [
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: List.generate(10, (index) {
                                                            int number = index + 1;
                                                            bool isActive = number == _rpeValue.round();
                                                            return Column(
                                                                children: [
                                                                    Text(
                                                                        '$number',
                                                                        style: TextStyle(
                                                                            fontSize: isActive ? 18 : 14,
                                                                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                                                            color: isActive ? _getColorForRPE(_rpeValue.toDouble()) : Colors.grey,
                                                                        ),
                                                                    ),
                                                                    SizedBox(height: 4),
                                                                    Container(
                                                                        width: 4,
                                                                        height: 10,
                                                                        color: isActive ? _getColorForRPE(_rpeValue.toDouble()) : Colors.grey[300],
                                                                    ),
                                                                ],
                                                            );
                                                        }),
                                                    ),
                                                    SizedBox(height: 10),
                                                    SliderTheme(
                                                        data: SliderThemeData(
                                                            trackHeight: 8,
                                                            thumbShape: RoundSliderThumbShape(
                                                                enabledThumbRadius: 16,
                                                            ),
                                                            overlayShape: RoundSliderOverlayShape(overlayRadius: 24),
                                                            activeTrackColor: _getColorForRPE(_rpeValue),
                                                            inactiveTrackColor: Colors.grey[300],
                                                            thumbColor: Colors.white,
                                                            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                                            valueIndicatorColor: _getColorForRPE(_rpeValue),
                                                            valueIndicatorTextStyle: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                            ),
                                                            showValueIndicator: ShowValueIndicator.always,
                                                        ),
                                                        child: Slider(
                                                            value: _rpeValue,
                                                            min: 1,
                                                            max: 10,
                                                            divisions: 9,
                                                            label: '${_rpeValue.round()}',
                                                            onChanged: (value) {
                                                                setState(() {
                                                                    _rpeValue = value;
                                                                });
                                                            },
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                            final prefs = await SharedPreferences.getInstance();                                                
                                            prefs.setInt('rpe_value', _rpeValue.round());
                                           
                                            int _testRpe = prefs.getInt('rpe_value')!;
                                            print(_testRpe);

                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(builder: (context) => CongratulationsScreen()),
                                            );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                            ),
                                        ),
                                        child: Text(
                                            'Vissza a kezdőlapra',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                            ),
                                        ),
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}