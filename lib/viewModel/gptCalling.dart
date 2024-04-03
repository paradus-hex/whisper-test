// import 'package:dio/dio.dart';

// class OpenAIService {
//   final Dio _dio = Dio();
//   final String _apiKey =
//       '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'; // Securely store your API key
//   final String _baseUrl = 'https://api.openai.com/v1/chat/completions';

//   Future<String> processConversation(String conversation) async {
//     try {
//       _dio.interceptors.add(LogInterceptor(responseBody: true));
//       final response = await _dio.post(
//         _baseUrl,
//         options: Options(headers: {
//           'Authorization': 'Bearer $_apiKey',
//           'Content-Type': 'application/json',
//         }),
//         data: {
//           'model': 'gpt-3.5-turbo-1106', // Specify the model you're using
//           'temperature': 0.7,
//           'messages': [
//             {
//               "role": "user",
//               "content":
//                   "Summarize the following conversation, analyze the key points, and provide recommended actions:\n\n$conversation"
//             }
//           ]
//         },
//       );

//       if (response.statusCode == 200) {
//         return response.data['choices'][0]['message']['content'];
//       } else {
//         return 'Error: Unable to process conversation';
//       }
//     } catch (e) {
//       return 'Exception: $e';
//     }
//   }

//   String buildPrompt(String conversation) {
//     // Customize this prompt according to your requirements
//     return 'Summarize the following text, analyze the key points, and provide recommended actions:\n\nThis is the text:$conversation';
//   }
// }
