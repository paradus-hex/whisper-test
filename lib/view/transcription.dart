import 'package:flutter/material.dart';

class TranscriptionScreen extends StatelessWidget {
  final String transcript;

  const TranscriptionScreen({super.key, required this.transcript});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transcription Result'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Transcript'),
              Tab(text: 'Summary'),
              Tab(text: 'Recommended Actions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Each tab content goes here:
            TranscriptTab(transcript: transcript),
            SummaryTab(transcript: transcript),
            RecommendedActionsTab(transcript: transcript),
          ],
        ),
      ),
    );
  }
}

class TranscriptTab extends StatelessWidget {
  final String transcript;

  const TranscriptTab({super.key, required this.transcript});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text(transcript, style: TextStyle(fontSize: 16)),
    );
  }
}

class SummaryTab extends StatelessWidget {
  final String transcript;

  const SummaryTab({Key? key, required this.transcript}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder for summary content
    return const Center(child: Text("Summary content goes here"));
  }
}

class RecommendedActionsTab extends StatelessWidget {
  final String transcript;

  const RecommendedActionsTab({super.key, required this.transcript});

  @override
  Widget build(BuildContext context) {
    // Placeholder for recommended actions content
    return const Center(child: Text("Recommended actions content goes here"));
  }
}
