import 'package:flutter/material.dart';
import 'questionaire.dart';
import 'question3.dart';

class Question2Page extends StatefulWidget {
  final QuestionnaireData data;
  const Question2Page({Key? key, required this.data}) : super(key: key);
  @override
  _Question2PageState createState() => _Question2PageState();
}

class _Question2PageState extends State<Question2Page> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('2. kérdés')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Hány térdelő fekvőtámaszt tudsz?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _buildOption('< 10', 0),
            SizedBox(height: 10),
            _buildOption('10-20', 1),
            SizedBox(height: 10),
            _buildOption('20+', 2),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected != null
                    ? () {
                        prefs?.setInt('knee_pushups', _selected!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Question3Page(data: widget.data)));
                      }
                    : null,
                child: Text('Következő kérdés'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String text, int value) {
    return InkWell(
      onTap: () => setState(() {
        _selected = value;
        widget.data.knee_pushups = value;
      }),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selected == value ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text),
      ),
    );
  }
}