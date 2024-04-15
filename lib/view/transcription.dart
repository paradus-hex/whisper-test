import 'package:flutter/material.dart';

class TranscriptionScreen extends StatelessWidget {
  final String transcript;
  final String summary;
  final String recommendedActions;

  const TranscriptionScreen({
    super.key,
    required this.transcript,
    required this.summary,
    required this.recommendedActions,
  });

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
            TranscriptTab(transcript: transcript),
            SummaryTab(summary: summary),
            RecommendedActionsTab(recommendedActions: recommendedActions),
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
  final String summary;

  const SummaryTab({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text(summary, style: TextStyle(fontSize: 16)),
    );
  }
}

class RecommendedActionsTab extends StatelessWidget {
  final String recommendedActions;

  const RecommendedActionsTab({Key? key, required this.recommendedActions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Text(recommendedActions, style: TextStyle(fontSize: 16)),
    );
  }
}
