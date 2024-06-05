import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security & Privacy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Your Security Matters',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Adjust color to match your app's theme
                ),
              ),
            ),
            SecurityOption(
              title: 'Enable Two-Factor Authentication',
              description: 'Add an extra layer of security to your account by enabling two-factor authentication (2FA).',
              onPressed: () {
                // Implement logic to enable 2FA
              },
            ),
            const Divider(), // Add a divider for visual separation
            SecurityOption(
              title: 'Manage Privacy Settings',
              description: 'Control who can see your posts, photos, and other content by managing your privacy settings.',
              onPressed: () {
                // Implement logic to manage privacy settings
              },
            ),
            const Divider(), // Add a divider for visual separation
            SecurityOption(
              title: 'Password Management',
              description: 'Update your password regularly and ensure it is strong and unique to protect your account.',
              onPressed: () {
                // Implement logic for password management
              },
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Report a Security Issue',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Adjust color to match your app's theme
                ),
              ),
            ),
            const Text(
              'If you believe your account has been compromised or you have encountered a security vulnerability, please report it to us immediately at:',
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

class SecurityOption extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const SecurityOption({super.key, 
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
