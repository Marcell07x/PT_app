import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'workout_done_screen.dart';
import 'feedback_execution.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: WorkoutFeedback(),
        );
    }
}

class WorkoutFeedback extends StatefulWidget {
    @override
    _WorkoutFeedbackState createState() => _WorkoutFeedbackState();
}

class _WorkoutFeedbackState extends State<WorkoutFeedback> {
    double _rpeValue = 5.0;
    
    List<String> _rpeDescriptions = [];

    Color _getColorForRPE(double value) {
        int roundedValue = value.round();
        if (roundedValue <= 3) return Colors.green;
        if (roundedValue <= 6) return Colors.lightGreen;
        if (roundedValue <= 8) return Colors.orange[600]!;
        return Colors.red;
    }
    
    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        _rpeDescriptions = [
            AppLocalizations.of(context)!.rpe1,
            AppLocalizations.of(context)!.rpe23,
            AppLocalizations.of(context)!.rpe23,
            AppLocalizations.of(context)!.rpe46,
            AppLocalizations.of(context)!.rpe46,
            AppLocalizations.of(context)!.rpe46,
            AppLocalizations.of(context)!.rpe78,
            AppLocalizations.of(context)!.rpe78,
            AppLocalizations.of(context)!.rpe910,
            AppLocalizations.of(context)!.rpe910
        ];
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(AppLocalizations.of(context)!.feedback),
            ),
            body: SafeArea(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                        children: [
                            SizedBox(height: 20),
                            Text(
                                AppLocalizations.of(context)!.howWasTheWorkout,
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                    ),
                                ),
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
                                                        _rpeDescriptions.isNotEmpty ? _rpeDescriptions[_rpeValue.round() - 1] : '',
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
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                            final prefs = await SharedPreferences.getInstance();                                                
                                            await prefs.setInt('rpe_value', _rpeValue.round());
                                            
                                            await FeedbackExecution.executeOnFeedback();

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
                                            AppLocalizations.of(context)!.next,
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