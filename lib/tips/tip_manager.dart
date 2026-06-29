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
    // New key to track if all tips have been seen at least once
    static const String _keyHasCompletedFullCycle = 'hasCompletedFullCycle';

    String? currentTipId;
    bool isNewTipForSession = false;

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
        
        // Check if we should transition to advanced tips
        if (!hasFinishedA && currentLevel >= 150) {
            bool hasCompletedFullCycle = prefs.getBool(_keyHasCompletedFullCycle) ?? false;
            
            if (hasCompletedFullCycle) {
                // User has seen all tips at least once AND reached level 150
                // Immediately switch to advanced tips
                hasFinishedA = true;
                prefs.setBool(_keyHasFinishedSectionA, true);
                prefs.remove(_keySeenTipsA);
                prefs.remove(_keyHasCompletedFullCycle); // Clean up
                return _getNextSectionBTip(prefs);
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

        // Check if all beginner tips have been seen at least once
        bool allPrinciplesSeen = TipsData.principles.every((t) => seenTipsA.contains(t.id));
        bool allBeginnerWorkoutSeen = TipsData.beginnerWorkout.every((t) => seenTipsA.contains(t.id));
        bool allBeginnerDietSeen = TipsData.beginnerDiet.every((t) => seenTipsA.contains(t.id));
        bool allTipsSeen = allPrinciplesSeen && allBeginnerWorkoutSeen && allBeginnerDietSeen;

        // If user has completed a full cycle, mark it
        if (allTipsSeen) {
            // This is the key fix: mark that user has completed at least one full cycle
            prefs.setBool(_keyHasCompletedFullCycle, true);
            
            // If user has also reached level 150, this will be caught on next tip change
            // by _calculateNextTipId, which will immediately switch to advanced
            
            // Reset seen tips to start the cycle over
            seenTipsA.clear();
            
            // Start fresh with the first principle tip
            if (TipsData.principles.isNotEmpty) {
                _markAsSeen(prefs, TipsData.principles.first.id, seenTipsA);
                return TipsData.principles.first.id;
            }
            
            // Fallback: return first workout tip if principles is empty
            if (TipsData.beginnerWorkout.isNotEmpty) {
                _markAsSeen(prefs, TipsData.beginnerWorkout.first.id, seenTipsA);
                return TipsData.beginnerWorkout.first.id;
            }
        }

        // 1. Principles - show unseen principles first
        for (var tip in TipsData.principles) {
            if (!seenTipsA.contains(tip.id)) {
                _markAsSeen(prefs, tip.id, seenTipsA);
                return tip.id;
            }
        }

        // 2. Beginner (alternating workout and diet)
        String nextType = prefs.getString(_keyNextBeginnerType) ?? 'workout';
        List<TipItem> workoutList = TipsData.beginnerWorkout.where((t) => !seenTipsA.contains(t.id)).toList();
        List<TipItem> dietList = TipsData.beginnerDiet.where((t) => !seenTipsA.contains(t.id)).toList();

        // If one category is completely seen but the other isn't, just serve from the available one
        if (workoutList.isEmpty && dietList.isNotEmpty) {
            _markAsSeen(prefs, dietList.first.id, seenTipsA);
            return dietList.first.id;
        }
        
        if (dietList.isEmpty && workoutList.isNotEmpty) {
            _markAsSeen(prefs, workoutList.first.id, seenTipsA);
            return workoutList.first.id;
        }

        // Normal alternation when both categories have unseen tips
        if (nextType == 'workout' && workoutList.isNotEmpty) {
            prefs.setString(_keyNextBeginnerType, 'diet');
            _markAsSeen(prefs, workoutList.first.id, seenTipsA);
            return workoutList.first.id;
        } else if (nextType == 'diet' && dietList.isNotEmpty) {
            prefs.setString(_keyNextBeginnerType, 'workout');
            _markAsSeen(prefs, dietList.first.id, seenTipsA);
            return dietList.first.id;
        }
        
        // This shouldn't be reached, but just in case
        return TipsData.principles.isNotEmpty ? TipsData.principles.first.id : '';
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
        return TipsData.advancedWorkout.isNotEmpty ? TipsData.advancedWorkout.first.id : '';
    }
}