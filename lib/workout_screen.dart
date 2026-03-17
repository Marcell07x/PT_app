import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';
import 'main.dart';

class WorkoutScreen extends StatefulWidget {
    final String videoPath;
    final String exerciseName;
    final String reps;
    final String description;
    final String buttonText;
    final String label;
    final VoidCallback onNextPressed;
    final VoidCallback onPreviousPressed;
    final int currentIndex;
    final int totalWorkouts;

    const WorkoutScreen({
        super.key,
        required this.videoPath,
        required this.exerciseName,
        required this.reps,
        required this.description,
        required this.buttonText,
        required this.label,
        required this.onNextPressed,
        required this.onPreviousPressed,
        required this.currentIndex,
        required this.totalWorkouts,
    });

    @override
    _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
    late VideoPlayerController _controller;
    double _videoAspectRatio = 16 / 9;

    @override
    void initState() {
        super.initState();
        _initializeVideo();
    }

    void _initializeVideo() {
        _controller = VideoPlayerController.asset(widget.videoPath)
            ..initialize().then((_) {
                if (_controller.value.isInitialized) {
                    setState(() {
                        _videoAspectRatio = _controller.value.aspectRatio;
                    });
                }
                _controller.setLooping(true);
                _controller.setVolume(0.0);
                _controller.play();
            });

        _controller.addListener(() {
            if (_controller.value.position >= _controller.value.duration) {
                _controller.seekTo(Duration.zero);
            }
        });
    }

    @override
    void didUpdateWidget(WorkoutScreen oldWidget) {
        super.didUpdateWidget(oldWidget);
        if (oldWidget.videoPath != widget.videoPath) {
            _controller.dispose();
            _initializeVideo();
        }
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            
            home: Scaffold(
                appBar: AppBar(
                    title: Text(
                        '${widget.label} ' '(${widget.currentIndex + 1}/${widget.totalWorkouts})',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                    backgroundColor: Colors.blue,
                    leading: IconButton(
                        icon: Icon(
                            Icons.home,
                            color: Colors.white,
                        ),
                        onPressed: () { Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const MyApp(),
                                ),
                                (Route<dynamic> route) => false,
                            );
                        },
                    ),
                ),
                body: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            children: [
                                LinearProgressIndicator(
                                    value: (widget.currentIndex + 1) / widget.totalWorkouts,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                                SizedBox(height: 20),
                                Container(
                                    width: double.infinity,
                                    constraints: BoxConstraints(
                                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                                    ),
                                    child: AspectRatio(
                                        aspectRatio: _videoAspectRatio,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey.withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(0, 3),
                                                    ),
                                                ],
                                            ),
                                            child: _controller.value.isInitialized
                                                ? VideoPlayer(_controller)
                                                : Center(
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                            CircularProgressIndicator(),
                                                            SizedBox(height: 10),
                                                        ],
                                                    ),
                                                ),
                                        ),
                                    ),
                                ),
                                SizedBox(height: 25),
                                Text(
                                    widget.exerciseName,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 15),
                                Text(
                                    widget.reps,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Container(
                                    height: 4,
                                    color: Colors.blue,
                                ),
                                SizedBox(height: 15),
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(left: 16),
                                    child: Text(
                                        widget.description,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.left,
                                    ),
                                ),
                                Spacer(),
                                Row(
                                    children: [
                                        if (widget.currentIndex > 0 || widget.label == AppLocalizations.of(context)!.workout)
                                            Expanded(
                                                child: ElevatedButton(
                                                    onPressed: widget.onPreviousPressed,
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.grey,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(25),
                                                        ),
                                                    ),
                                                    child: Text(
                                                        AppLocalizations.of(context)!.goback,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                        ),
                                                    ),
                                                ),
                                            ),
                                        if (widget.currentIndex > 0 || widget.label == AppLocalizations.of(context)!.workout) 
                                            SizedBox(width: 10),
                                        Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                                height: 50,
                                                child: ElevatedButton(
                                                    onPressed: widget.onNextPressed,
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.blue,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(25),
                                                        ),
                                                    ),
                                                    child: Text(
                                                        widget.buttonText,
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
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}