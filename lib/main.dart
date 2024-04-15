import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/view/transcription.dart';
import 'package:flutter_application_1/viewModel/gptCalling.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Dio _dio = Dio();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;
  String _transcription = 'Press the button to start recording';
  String? filePathOriginal;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }

  Future<String> _startRecording() async {
    Directory? externalDir =
        await getExternalStorageDirectory(); // Deprecated for Android
    filePathOriginal =
        '${externalDir?.path}/${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.startRecorder(
        toFile: filePathOriginal, codec: Codec.pcm16WAV);
    return filePathOriginal!;
  }

  Future<void> _stopRecording(String filePath, context) async {
    await _recorder.stopRecorder();
    _transcribeAudio(filePath, context);
  }

  Future<void> _transcribeAudio(String filePath, BuildContext context) async {
    if (!_isRecorderInitialized) return;

    try {
      FormData formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(filePath,
            filename: filePath.split("/").last),
      });

      var response =
          await _dio.post('http://10.0.2.2:3000/transcribe', data: formData);

      if (response.statusCode == 200) {
        var data = response.data;
        String transcript =
            data['results']['channels'][0]['alternatives'][0]['transcript'];

        // Navigate to TranscriptionScreen and wait for it to pop.
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TranscriptionScreen(transcript: transcript),
          ),
        );

        // When TranscriptionScreen pops, reset the UI
        setState(() {
          _transcription = 'Press the button to start recording';
        });
      } else {
        setState(() {
          _transcription =
              'Failed to transcribe audio: ${response.statusMessage}';
        });
      }
    } catch (e) {
      setState(() {
        _transcription = 'An error occurred: $e';
      });
    }
  }

// Inside the build method of _MyAppState
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Record & Transcribe'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_transcription),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  // Use Builder to get the correct context
                  builder: (BuildContext innerContext) {
                    // innerContext is the correct context
                    return ElevatedButton(
                      onPressed: () async {
                        if (_recorder.isRecording) {
                          _stopRecording(filePathOriginal!, innerContext);
                        } else {
                          String path = await _startRecording();
                          setState(() {
                            _transcription = "Recording...";
                          });
                          Future.delayed(const Duration(seconds: 100),
                              () => _stopRecording(path, innerContext));
                        }
                      },
                      child: Text(_recorder.isRecording
                          ? 'Stop Recording'
                          : 'Start Recording'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
