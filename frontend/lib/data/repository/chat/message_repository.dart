import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:frontend/constants/api.dart';

import 'package:http/http.dart' as http;

class MessageRepository {
<<<<<<< Updated upstream
=======
  final String baseurl = BOT_BASE_URL;
  final String serverUrl = SERVER_BASE_URL;

>>>>>>> Stashed changes
  MessageRepository();

  Future<String> queryPrompt(String prompt) async {
    try {
      final response = await http
          .post(
            Uri.parse('$BOT_BASE_URL/api/getModelInf'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              // TO DO: IMPLEMENT AFTER DATABASE IS SET-UP
              // HttpHeaders.authorizationHeader: 'Basic $base64Encode(utf8.encode('$username:$password'))',
            },
            body: jsonEncode({'prompt': prompt}),
          )
          .timeout(const Duration(seconds: 15)); // Set the timeout to 5 seconds

      String returnPrompt = jsonDecode(response.body);
      return returnPrompt;
    } on TimeoutException {
      return "The request timed out. Please try again.";
    } catch (e) {
      return "I apologize, there was an error processing your query. Please try again.";
    }
  }

  Future<String> createMessage(
      String chatId, bool isBot, String payload, DateTime timestamp) async {
    try {
      final response = await http
          .post(
            Uri.parse('$serverUrl/api/createMessage'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({
              'chatId': chatId,
              'isBot': isBot,
              'payload': payload,
              'timestamp': timestamp.toIso8601String(),
            }),
          )
          .timeout(const Duration(seconds: 15)); // Set the timeout to 5 seconds

      print(response.statusCode);

      // Handle response based on status code or body content
      // For example:
      if (response.statusCode == 200) {
        return "Message created successfully.";
      } else {
        return "Failed to create message. Status code: ${response.statusCode}";
      }
    } on TimeoutException {
      return "The request timed out. Please try again.";
    } catch (e) {
      return "An error occurred while creating the message: $e";
    }
  }
}
