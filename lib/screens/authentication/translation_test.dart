import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslatedScreen extends StatefulWidget {
  const TranslatedScreen({super.key});

  @override
  State<TranslatedScreen> createState() => _TranslatedScreenState();
}

class _TranslatedScreenState extends State<TranslatedScreen> {
  final GoogleTranslator translator = GoogleTranslator();

  String originalText = "Welcome to the Temple Application";
  // String Text = "Loading...";
  late String text = originalText;

  @override
  void initState() {
    super.initState();
    translateText();
  }

  Future<void> translateText() async {
    var translation = await translator.translate(
      originalText,
      to: 'mr', // Hindi (change to 'mr', 'ta', 'te', etc.)
    );

    setState(() {
      text = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Translated Screen")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Original:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(originalText),

            const SizedBox(height: 24),

            Text(
              "Translated:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
