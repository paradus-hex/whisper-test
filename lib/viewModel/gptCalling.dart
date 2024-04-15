import 'package:dio/dio.dart';
import 'dart:convert';

class OpenAIService {
  final Dio _dio = Dio();
  final String _apiKey =
      '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'; // Securely store your API key
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
                  "Summarize the following conversation and provide recommended actions. Your output should be in valid JSON format, using double quotes for keys and values, and escaping necessary characters. The format should be as follows: {\"summary\": \"<summary content>\", \"actions\": \"<recommended actions go here>\"}\n\n$conversation"
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
