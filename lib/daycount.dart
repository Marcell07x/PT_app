import 'package:shared_preferences/shared_preferences.dart';

class Daycount {

  void setDayCount (variable) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      variable = prefs.getInt('Days') ?? 0;
      variable++;
      print(variable);
      prefs.setInt('Days', variable);
  }

}