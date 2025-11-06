import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

prefsInit() async {
    prefs = await SharedPreferences.getInstance();
}

class QuestionnaireData {
  String? main_goal;
  int? knee_pushups; 
  int? bw_squats; 
  bool? previous_exp_1; 
  bool? previous_exp_2; 
  int? motivation;
  int? age;
}