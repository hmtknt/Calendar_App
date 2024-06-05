import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Your Privacy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Adjust color to match your app's theme
              ),
            ),
            const SizedBox(height: 20),
            PrivacyOption(
              title: 'Profile Visibility',
              description: 'Control who can see your profile information, including your name, profile picture, and bio.',
              onPressed: () {
                // Implement logic to manage profile visibility
              },
            ),
            const Divider(), // Add a divider for visual separation
            PrivacyOption(
              title: 'Event Visibility',
              description: 'Choose who can see your scheduled events and event details.',
              onPressed: () {
                // Implement logic to manage event visibility
              },
            ),
            const Divider(), // Add a divider for visual separation
            PrivacyOption(
              title: 'Location Sharing',
              description: 'Manage whether your location is shared with others when you create or join events.',
              onPressed: () {
                // Implement logic to manage location sharing
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Need Help?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Adjust color to match your app's theme
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you have any questions or concerns about your privacy settings, please contact us at:',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Implement logic to open email client
              },
              child: const Text(
                'Email: hmtsmkunt@gmail.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue, // Add a hyperlink style
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyOption extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const PrivacyOption({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200], // Adjust color to match your app's theme
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Adjust color to match your app's theme
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54, // Adjust color to match your app's theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
