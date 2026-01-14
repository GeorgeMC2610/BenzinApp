import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<StatefulWidget> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String _markdownContent = '';

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    final content = await rootBundle.loadString('assets/long_screens/privacy_policy_$languageCode.md');
    setState(() {
      _markdownContent = content;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Privacy Policy")
    ),
    body: _markdownContent.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Markdown(
      data: _markdownContent,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: const TextStyle(fontSize: 16.0, height: 1.5),
        h1: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w900),
        h2: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
        h3: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
      ),
    ),
  );
}