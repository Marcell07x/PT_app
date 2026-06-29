import "package:shared_preferences/shared_preferences.dart";

class FeedbackExecution {
    static Future<void> executeOnFeedback() async {
        final prefs = await SharedPreferences.getInstance();

        int rpe = prefs.getInt('rpe_value') ?? 5;
        int level = prefs.getInt('level')!;
        int inc = prefs.getInt('incspeed')!;

        //people shouldn't be able to drop back to phase A from phase B
        if ((150 <= level && level < 170 && rpe == 10) ||
            (150 <= level && level < 160 && rpe == 9)) {
                level = 150;
        } else if (rpe == 1) {
            level += 20;
            inc += 3; 
        } else if (rpe == 2) {
            level += 10;
            inc += 1; 
        } else if (rpe == 3) {
            inc += 3; 
        } else if (rpe == 4) {
            inc += 1; 
        } else if (rpe == 7) {
            inc -= 1; 
        } else if (rpe == 8) {
            inc -= 3; 
        } else if (rpe == 9) {
            level -= 10;
            inc -= 1; 
        } else if (rpe == 10) {
            level -= 20;
            inc -= 3; 
        }

        if (inc < 0) {
            inc = 1;
        }

        if (rpe != 5 && rpe != 6) {
            await prefs.setInt('incspeed', inc);
            await prefs.setInt('level', level);
        }
    }
}