import 'questionaire.dart';
import 'package:flutter/material.dart';
import 'question7.dart';

class Question6Page extends StatefulWidget {
  final QuestionnaireData data;
  const Question6Page({Key? key, required this.data}) : super(key: key);
  @override
  _Question6PageState createState() => _Question6PageState();
}

class _Question6PageState extends State<Question6Page> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('6. kérdés')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Mennyire van kedved edzeni?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _buildOption('Szinte semmennyire', 1),
            SizedBox(height: 10),
            _buildOption('Nem igazán', 2),
            SizedBox(height: 10),
            _buildOption('Motivált vagyok', 3),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected != null
                    ? () {
                        prefs?.setInt('motivation', _selected!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Question7Page(data: widget.data)));
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
        widget.data.motivation = value;
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