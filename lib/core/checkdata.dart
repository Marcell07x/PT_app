import 'package:shared_preferences/shared_preferences.dart';

class CheckData {
    static Future<bool> checkData() async {
        final prefs = await SharedPreferences.getInstance();
        
        int pushe = prefs.getInt('pushe') ?? 0;
        int legse = prefs.getInt('legse') ?? 0;
        int pulle = prefs.getInt('pulle') ?? 0;
        int coree = prefs.getInt('coree') ?? 0;
        int incspeed = prefs.getInt('incspeed') ?? 0;

        return !(pushe == 0 || legse == 0 || pulle == 0 || coree == 0 || incspeed == 0);
    }
}