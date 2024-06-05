import 'package:flutter/material.dart';

class EventTipsScreen extends StatelessWidget {
  const EventTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Tips'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event Planning Tips',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              EventTipCard(
                title: 'Set Clear Goals',
                description: 'Define the purpose and objectives of your event to guide planning and execution.',
              ),
              EventTipCard(
                title: 'Create a Budget',
                description: 'Estimate costs for venue, catering, decorations, and other expenses to stay within budget.',
              ),
              EventTipCard(
                title: 'Choose the Right Venue',
                description: 'Select a venue that suits the size, theme, and requirements of your event.',
              ),
              EventTipCard(
                title: 'Plan Ahead',
                description: 'Create a timeline and checklist to ensure all tasks are completed before the event.',
              ),
              EventTipCard(
                title: 'Promote Your Event',
                description: 'Use social media, email marketing, and other channels to reach your target audience.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventTipCard extends StatelessWidget {
  final String title;
  final String description;

  const EventTipCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
