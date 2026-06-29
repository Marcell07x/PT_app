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

        if (kneePushups == 0 && age == 3 && !prevExp1) {
            _pushe = 1;
        } else if (kneePushups == 0 && (age != 3 || prevExp1)) {
            _pushe = 2;
        } else if (kneePushups == 1) {
            _pushe = 3;
        } else if (kneePushups == 2) {
            _pushe = 4;
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


        if (prevExp1) {
          _incSpeed++;
        }

        if (prevExp2) {
          _incSpeed++;
        }

        _incSpeed += motivation;

        await prefs.setInt('pushe', _pushe);
        await prefs.setInt('legse', _legse);
        await prefs.setInt('pulle', _pulle);
        await prefs.setInt('coree', _coree);
        await prefs.setInt('incspeed', _incSpeed);
    }
}