// ignore_for_file: todo, avoid_print, deprecated_member_use, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/widgets/dialogue/version_update_dialogue.dart';

class CacheClearAppVersionService {
  static Future<void> clearCache() async {
    final url = Uri.parse(GlobalConstants.cacheclearurl);
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        print('Cache cleared successfully: ${response.body}');
      } else {
        print('Failed to clear cache. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  static bool _isNewer(String latest, String current) {
    final l = latest.split('.').map(int.tryParse).toList();
    final c = current.split('.').map(int.tryParse).toList();
    for (int i = 0; i < l.length; i++) {
      final lv = i < l.length ? (l[i] ?? 0) : 0;
      final cv = i < c.length ? (c[i] ?? 0) : 0;
      if (lv > cv) return true;
      if (lv < cv) return false;
    }
    return false;
  }

  static Future<void> checkAppVersion(BuildContext context) async {
    //TODO::: current version is same as pubspec.yaml file
    // Make an HTTP request to your server or a version-check API
    final url = Uri.parse(GlobalConstants.chechversionurl);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String latestVersion =
            data['resultData']['version']; //TODO::: latest version is one previous version of the currenct app ...

        const String currentVersion =
            '1.1.13'; // Replace with your app's current version //TODO::: current version is same as pubspec.yaml file . with updated one which you gonna push on play store..

        if (_isNewer(latestVersion, currentVersion)) {
          // Display u  pdate notificationra
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  // Define your custom logic here to determine whether the dialog should close or not.
                  // Return true to allow the dialog to close or false to prevent it from closing.
                  return false; // Change this as needed.
                },
                child: const CustomDialog(),
              );
            },
          );
        }
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching data: $e');
    }
  }
}
