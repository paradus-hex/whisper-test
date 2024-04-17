import 'package:dio/dio.dart';
import 'dart:convert';

class OpenAIService {
  final Dio _dio = Dio();
  final String _apiKey = ''; // Securely store your API key
  final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<dynamic> processConversation(String conversation) async {
    try {
      _dio.interceptors.add(LogInterceptor(responseBody: true));
      final response = await _dio.post(
        _baseUrl,
        options: Options(headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        }),
        data: {
          'model': 'gpt-3.5-turbo-1106', // Specify the model you're using
          'temperature': 0.7,
          'messages': [
            {
              "role": "user",
              "content":
                  "Please provide a detailed summary of the following conversation, highlighting the key points and main topics discussed. Additionally, suggest a list of recommended actions based on the discussion. Present the actions as a numbered list to clarify the sequence of steps that should be taken.The format should be as follows: {\"summary\": \"<summary content>\", \"actions\": \"<recommended actions go here>\"}\n\n$conversation"
            }
          ]
        },
      );

      if (response.statusCode == 200) {
        var jsonString = response.data['choices'][0]['message']['content'];
        var decoded = json.decode(jsonString);

        var summary = decoded['summary'];
        var actions = decoded['actions'];

        return {'summary': summary, 'actions': actions};
      } else {
        return 'Error: Unable to process conversation';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }

  String buildPrompt(String conversation) {
    // Customize this prompt according to your requirements
    return 'Summarize the following text, analyze the key points, and provide recommended actions:\n\nThis is the text:$conversation';
  }
}
