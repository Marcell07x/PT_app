import 'package:shared_preferences/shared_preferences.dart';

class Converter {
    int? pushe;
    int? pulle;
    int? legse;
    int? coree;

    Future<void> calculateAll() async {
        final prefs = await SharedPreferences.getInstance();
        
        int kneePushups = prefs.getInt('knee_pushups') ?? 0;
        int age = prefs.getInt('age') ?? 0;

        if (kneePushups == 0 && age == 3) {
            pushe = 1;
        } else if (kneePushups == 0 && age != 3) {
            pushe = 2;
        } else if (kneePushups == 1) {
            pushe = 3;
        } else if (kneePushups == 2) {
            pushe = 4;
        }  

        int bwSquats = prefs.getInt('bw_squats') ?? 0;

        if (bwSquats == 0) {
            legse = 1;
        } else if (bwSquats == 1) {
            legse = 3;
        } else if (bwSquats == 2) {
            legse = 5;
        } 

        pulle = 1;
        coree = 1;
    }
}