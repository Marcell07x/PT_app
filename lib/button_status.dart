import 'package:shared_preferences/shared_preferences.dart';

class StatusManager {
    static String _status = '';
    static bool _isFirstTime = true;

    static String get status => _status;
    static bool get isFirstTime => _isFirstTime;

    static Future<void> loadStatus() async {
        try {
            final prefs = await SharedPreferences.getInstance();
            _isFirstTime = !prefs.containsKey('status');
            _status = prefs.getString('status') ?? getTodayDate();
            
            if (_isFirstTime) {
                _status = '';
            }
        } catch (e) {
            _status = '';
            _isFirstTime = true;
        }
    }

    static Future<void> saveStatus(String newStatus) async {
        try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('status', newStatus);
            _status = newStatus;
            _isFirstTime = false;
        } catch (e) {
            print('Hiba a status mentésekor: $e');
        }
    }

    static String getTodayDate() {
        final now = DateTime.now();
        return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }

    static Future<void> resetStatus() async {
        final today = getTodayDate();
        await saveStatus(today);
    }
}