import 'package:shared_preferences/shared_preferences.dart';
//if finished, button_status.dart should be deleted


//goal: to make a variable, that is set true the secound day after 
//it was set to false, and to do it a maximum amount of 3 times a week
class WorkoutSignal {
    static late String _key = "signal";
    static late bool signal;
    static String? _lastworkoutdate;

    //checks if there's a workout the user should do
    static Future<void> getSignal() async {
        final prefs = await SharedPreferences.getInstance();
        signal = prefs.getBool(_key) ?? true;
    }

    //sets the signal false after the workout has been done, and saves the date
    static Future<void> setSignalFalse() async {
        final prefs = await SharedPreferences.getInstance();
        signal = false;
        prefs.setBool(_key, false);
        //i dont know how to save dates in the memory
    }

    //sets the signal true the next day after the signal was set to false
    //only if the level is below 150
    static Future<void> setSignalTrueA() async {

    }

    //sets the signal true the second day after it has been set to false
    //only if the level is above 149 and the number of workout that week is less than 3
    static Future<void> setSignalTrueB() async {

    }
}