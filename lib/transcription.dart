import 'package:flutter/material.dart';

class TranscriptionScreen extends StatelessWidget {
  final String transcript;

  const TranscriptionScreen({super.key, required this.transcript});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transcription Result'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Text(transcript, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
