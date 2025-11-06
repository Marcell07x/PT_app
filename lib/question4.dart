import 'questionaire.dart';
import 'package:flutter/material.dart';
import 'question5.dart';

class Question4Page extends StatefulWidget {
  final QuestionnaireData data;
  const Question4Page({Key? key, required this.data}) : super(key: key);
  @override
  _Question4PageState createState() => _Question4PageState();
}

class _Question4PageState extends State<Question4Page> {
  bool? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('4. kérdés')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Sportoltál-e régebben rendszeresen?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _buildOption('Igen', true),
            SizedBox(height: 10),
            _buildOption('Nem', false),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected != null
                    ? () {
                        prefs?.setBool('previous_exp_1', _selected!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Question5Page(data: widget.data)));
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

  Widget _buildOption(String text, bool value) {
    return InkWell(
      onTap: () => setState(() {
        _selected = value;
        widget.data.previous_exp_1 = value;
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