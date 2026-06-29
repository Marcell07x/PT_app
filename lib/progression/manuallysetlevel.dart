import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManuallySetLevel {
    static Future<int?> showLevelInputDialog(BuildContext context) async {
        TextEditingController controller = TextEditingController();
        
        return await showDialog<int>(
            context: context,
            builder: (context) {
                return AlertDialog(
                    title: Text('Set Level'),
                    content: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        decoration: InputDecoration(
                            hintText: 'Enter a number',
                            border: OutlineInputBorder(),
                        ),
                    ),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                                try {
                                    int newLevel = int.parse(controller.text);
                                    Navigator.pop(context, newLevel);
                                } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Invalid number!'),
                                            backgroundColor: Colors.red,
                                        ),
                                    );
                                }
                            },
                            child: Text('OK'),
                        ),
                    ],
                );
            },
        );
    }

    static Future<void> saveLevelToPrefs(int level) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('level', level);
    }

    static Future<int> loadLevelFromPrefs() async {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getInt('level') ?? 1;
    }

    static void showSuccess(BuildContext context, String message) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(message),
                backgroundColor: Colors.green,
            ),
        );
    }
}