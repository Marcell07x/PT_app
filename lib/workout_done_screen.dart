import 'package:flutter/material.dart';
import 'daycount.dart';

class CongratulationsScreen extends StatelessWidget {

  Daycount daycount = Daycount();
  int? days;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.celebration,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(height: 30),
              Text(
                'Gratulálok!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Sikeresen elvégezted az edzést!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  daycount.setDayCount(days);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Befejezés',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}