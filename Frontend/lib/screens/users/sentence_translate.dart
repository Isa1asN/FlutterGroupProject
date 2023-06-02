import 'package:flutter/material.dart';

class TranslationPage extends StatelessWidget {
  final List<String> originalTexts;
  final List<String> translatedTexts;

  const TranslationPage({
    required this.originalTexts,
    required this.translatedTexts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentences'),
      ),
      backgroundColor: Color.fromARGB(255, 231, 233, 239),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: originalTexts.length,
        itemBuilder: (context, index) {
          String originalText = originalTexts[index];
          String translatedText = translatedTexts[index];
          return TranslationCard(
            originalText: originalText,
            translatedText: translatedText,
          );
        },
      ),
    );
  }
}

class TranslationCard extends StatelessWidget {
  final String originalText;
  final String translatedText;

  const TranslationCard({
    required this.originalText,
    required this.translatedText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              originalText,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              translatedText,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
