// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareLinkPage extends StatelessWidget {
  final String userId;
  final String userName;

  ShareLinkPage({required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Link'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _launchUrl(); // Launch the URL when the button is pressed
          },
          child: Text('Share Link'),
        ),
      ),
    );
  }

  // Function to construct and launch the URL
  Future<void> _launchUrl() async {
    // Construct the URL with user ID and name
    final url = 'https://google.com?userId=$userId&userName=$userName';

    // Check if the URL can be launched
    if (await canLaunch(url)) {
      // Launch the URL in the user's web browser
      await launch(url);
    } else {
      // Handle error if the URL cannot be launched
      throw 'Could not launch $url';
    }
  }
}
