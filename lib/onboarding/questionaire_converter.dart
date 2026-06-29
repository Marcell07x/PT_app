import 'package:shared_preferences/shared_preferences.dart';

class Converter {
    late int _pushe;
    late int _pulle;
    late int _legse;
    late int _coree;
    int _incSpeed = 1;

    Future<void> convert() async {
        final prefs = await SharedPreferences.getInstance();

        int kneePushups = prefs.getInt('knee_pushups') ?? 0;
        int age = prefs.getInt('age') ?? 0;
        int bwSquats = prefs.getInt('bw_squats') ?? 0;
        bool prevExp1 = prefs.getBool('previous_exp_1')!;
        bool prevExp2 = prefs.getBool('previous_exp_2')!;
        int motivation = prefs.getInt('motivation')!;
        String gender = prefs.getString('gender') ?? 'female';

        // incspeed is computed first, because the starting push-up exercise
        // depends on it (high incspeed + male starts on a harder variant).
        if (prevExp1) {
          _incSpeed++;
        }
        if (prevExp2) {
          _incSpeed++;
        }
        _incSpeed += motivation;

        // Starting push-up exercise (conservative on purpose):
        //   0-15 reps -> wall or table push-up (same wall/table logic as before)
        //   15+  reps -> knee push-up, except fit & motivated men (incspeed 5)
        //                who start on regular push-ups.
        if (kneePushups == 0) {
          if (age == 3 && !prevExp1) {
            _pushe = 1; // wall push-up
          } else {
            _pushe = 2; // table push-up
          }
        } else {
          if (_incSpeed == 5 && gender == 'male') {
            _pushe = 4; // regular push-up
          } else {
            _pushe = 3; // knee push-up
          }
        }

        if (bwSquats == 0) {
            _legse = 1;
        } else if (bwSquats == 1) {
            _legse = 3;
        } else if (bwSquats == 2) {
            _legse = 5;
        }

        _pulle = 1;
        _coree = 1;

        await prefs.setInt('pushe', _pushe);
        await prefs.setInt('legse', _legse);
        await prefs.setInt('pulle', _pulle);
        await prefs.setInt('coree', _coree);
        await prefs.setInt('incspeed', _incSpeed);
    }
}
