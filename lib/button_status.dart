import 'package:shared_preferences/shared_preferences.dart';

class StatusManager {
  static String _status = '';
  static bool _isFirstTime = true;

  static String get status => _status;
  static bool get isFirstTime => _isFirstTime;

  // Status betöltése Shared Preferences-ből
  static Future<void> loadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isFirstTime = !prefs.containsKey('status'); // Ellenőrizzük, hogy első alkalom-e
      _status = prefs.getString('status') ?? getTodayDate();
      
      // Ha első alkalom, akkor még NE mentsük el automatikusan
      if (_isFirstTime) {
        _status = ''; // Üres érték, hogy a gomb aktív legyen
      }
    } catch (e) {
      _status = '';
      _isFirstTime = true;
    }
  }

  // Status mentése Shared Preferences-be
  static Future<void> saveStatus(String newStatus) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('status', newStatus);
      _status = newStatus;
      _isFirstTime = false; // Már nem első alkalom
    } catch (e) {
      print('Hiba a status mentésekor: $e');
    }
  }

  // Mai dátum stringként
  static String getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // Status törlése (visszaállítás mai dátumra)
  static Future<void> resetStatus() async {
    final today = getTodayDate();
    await saveStatus(today);
  }
}