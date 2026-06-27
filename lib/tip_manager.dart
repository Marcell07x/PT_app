import 'package:shared_preferences/shared_preferences.dart';
import 'tips_data.dart';

class TipManager {
    static const String _keySeenTipsA = 'seenTipsA';
    static const String _keyHasFinishedSectionA = 'hasFinishedSectionA';
    static const String _keyLastTipId = 'lastTipId';
    static const String _keyLastTipChangeTime = 'lastTipChangeTime';
    static const String _keyNextBeginnerType = 'nextBeginnerType'; 
    static const String _keyNextAdvancedType = 'nextAdvancedType'; 
    static const String _keyAdvancedWorkoutIndex = 'advancedWorkoutIndex';
    static const String _keyAdvancedDietIndex = 'advancedDietIndex';
    static const String _keyLastOpenedTipId = 'lastOpenedTipId';

    String? currentTipId;
    bool isNewTipForSession = false;
    bool seenBegTipsOnce = 

    // Singleton pattern
    static final TipManager _instance = TipManager._internal();
    factory TipManager() => _instance;
    TipManager._internal();

    Future<void> initialize() async {
        final prefs = await SharedPreferences.getInstance();
        int currentLevel = prefs.getInt('level') ?? 1;
        
        currentTipId = prefs.getString(_keyLastTipId);
        // Store days since epoch instead of milliseconds
        final lastChangeDay = prefs.getInt(_keyLastTipChangeTime) ?? 0;
        final today = DateTime.now().millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000);
        
        bool shouldChangeTip = false;
        if (currentTipId == null || (today - lastChangeDay >= 3)) {
            shouldChangeTip = true;
        }

        if (shouldChangeTip) {
            currentTipId = _calculateNextTipId(prefs, currentLevel);
            await prefs.setString(_keyLastTipId, currentTipId!);
            // Store days since epoch
            await prefs.setInt(_keyLastTipChangeTime, today);
        }
          
        final lastOpenedTipId = prefs.getString(_keyLastOpenedTipId);
        if (lastOpenedTipId != currentTipId) {
            isNewTipForSession = true;
            await prefs.setString(_keyLastOpenedTipId, currentTipId!);
        } else {
            isNewTipForSession = false;
        }
    }

    String _calculateNextTipId(SharedPreferences prefs, int currentLevel) {
        bool hasFinishedA = prefs.getBool(_keyHasFinishedSectionA) ?? false;
        
        if (!hasFinishedA && currentLevel >= 150) {
            List<String> seenTipsA = prefs.getStringList(_keySeenTipsA) ?? [];
            bool allPrinciplesSeen = TipsData.principles.every((t) => seenTipsA.contains(t.id));
            bool allBeginnerWorkoutSeen = TipsData.beginnerWorkout.every((t) => seenTipsA.contains(t.id));
            bool allBeginnerDietSeen = TipsData.beginnerDiet.every((t) => seenTipsA.contains(t.id));
            
            if (allPrinciplesSeen && allBeginnerWorkoutSeen && allBeginnerDietSeen) {
                hasFinishedA = true;
                prefs.setBool(_keyHasFinishedSectionA, true);
                prefs.remove(_keySeenTipsA);
            }
        }

        if (hasFinishedA) {
            return _getNextSectionBTip(prefs);
        } else {
            return _getNextSectionATip(prefs, currentLevel);
        }
    }

    String _getNextSectionATip(SharedPreferences prefs, int currentLevel) {
        List<String> seenTipsA = prefs.getStringList(_keySeenTipsA) ?? [];

        // 1. Principles
        for (var tip in TipsData.principles) {
            if (!seenTipsA.contains(tip.id)) {
                _markAsSeen(prefs, tip.id, seenTipsA);
                return tip.id;
            }
        }

        // 2. Beginner (alternating)
        String nextType = prefs.getString(_keyNextBeginnerType) ?? 'workout';
        List<TipItem> workoutList = TipsData.beginnerWorkout.where((t) => !seenTipsA.contains(t.id)).toList();
        List<TipItem> dietList = TipsData.beginnerDiet.where((t) => !seenTipsA.contains(t.id)).toList();

        // 3. If all seen
        //not working properly: if it starts to show the beginner tips again, but the user reaches 150, it still shows beginner tips
        if (workoutList.isEmpty && dietList.isEmpty) {
            if (currentLevel < 150) {
                
                seenTipsA.clear();
                prefs.setStringList(_keySeenTipsA, seenTipsA);
                if (TipsData.principles.isNotEmpty) {
                    _markAsSeen(prefs, TipsData.principles.first.id, seenTipsA);
                    return TipsData.principles.first.id;
                }
            } else {
                prefs.setBool(_keyHasFinishedSectionA, true);
                prefs.remove(_keySeenTipsA);
                return _getNextSectionBTip(prefs);
            }
        }

        if (nextType == 'workout') {
            if (workoutList.isNotEmpty) {
                prefs.setString(_keyNextBeginnerType, 'diet');
                _markAsSeen(prefs, workoutList.first.id, seenTipsA);
                return workoutList.first.id;
            } else if (dietList.isNotEmpty) {
                _markAsSeen(prefs, dietList.first.id, seenTipsA);
                return dietList.first.id;
            }
        } else {
            if (dietList.isNotEmpty) {
                prefs.setString(_keyNextBeginnerType, 'workout');
                _markAsSeen(prefs, dietList.first.id, seenTipsA);
                return dietList.first.id;
            } else if (workoutList.isNotEmpty) {
                _markAsSeen(prefs, workoutList.first.id, seenTipsA);
                return workoutList.first.id;
            }
        }
        
        return TipsData.principles.isNotEmpty ? TipsData.principles.first.id : 'fallback';
    }

    void _markAsSeen(SharedPreferences prefs, String id, List<String> seenTipsA) {
        seenTipsA.add(id);
        prefs.setStringList(_keySeenTipsA, seenTipsA);
    }

    String _getNextSectionBTip(SharedPreferences prefs) {
        String nextType = prefs.getString(_keyNextAdvancedType) ?? 'workout';
        
        if (nextType == 'workout') {
            int idx = prefs.getInt(_keyAdvancedWorkoutIndex) ?? 0;
            if (idx >= TipsData.advancedWorkout.length) idx = 0;
            
            prefs.setInt(_keyAdvancedWorkoutIndex, idx + 1);
            prefs.setString(_keyNextAdvancedType, 'diet');
            
            if (TipsData.advancedWorkout.isNotEmpty) {
                return TipsData.advancedWorkout[idx].id;
            }
        } else {
            int idx = prefs.getInt(_keyAdvancedDietIndex) ?? 0;
            if (idx >= TipsData.advancedDiet.length) idx = 0;
            
            prefs.setInt(_keyAdvancedDietIndex, idx + 1);
            prefs.setString(_keyNextAdvancedType, 'workout');
            
            if (TipsData.advancedDiet.isNotEmpty) {
                return TipsData.advancedDiet[idx].id;
            }
        }
        return TipsData.advancedWorkout.isNotEmpty ? TipsData.advancedWorkout.first.id : 'fallback';
    }
}
