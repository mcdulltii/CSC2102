import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:frontend/constants/api.dart';
import 'package:frontend/data/model/message.dart';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class MessageRepository {
  final String baseurl = BOT_BASE_URL;
  final String serverUrl = SERVER_BASE_URL;

  MessageRepository();

  Future<String> queryPrompt(String prompt) async {
    try {
      final response = await http
          .post(
            Uri.parse('$BOT_BASE_URL/api/llm'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              // TO DO: IMPLEMENT AFTER DATABASE IS SET-UP
              // HttpHeaders.authorizationHeader: 'Basic $base64Encode(utf8.encode('$username:$password'))',
            },
            body: jsonEncode({'prompt': prompt}),
          )
          .timeout(const Duration(seconds: 30)); // Set the timeout to 15 seconds

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

  Future<void> deleteAllChatsByChatId(String chatId) async {
    try {
      // Initialize Dio instance
      Dio dio = Dio();
      // Make HTTP request to fetch data
      Response response =
          await dio.delete('$serverUrl/api/deleteMessages?chatId=$chatId');

      if (response.statusCode != 200) {
        throw Exception(
            "Status code: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception('Error fetching chats: $e');
    }
  }

  Future<List<Message>> getAllChatsByChatId(String chatId) async {
    try {
      List<Message> messages = [];

      // Initialize Dio instance
      Dio dio = Dio();
      // Make HTTP request to fetch data
      Response response =
          await dio.get('$serverUrl/api/getMessages?chatId=$chatId');

      // Parse response data into list of Message objects
      List<dynamic> responseData = response.data;
      for (var data in responseData) {
        messages.add(Message(
          chatId: data['chatId'],
          isBot: data['isBot'],
          payload: data['payload'],
          timestamp: DateTime.parse(data['timestamp']),
        ));
      }

      return messages;
    } catch (e) {
      // Handle errors here
      print('Error fetching chats: $e');
      return []; // Return empty list if error occurs
    }
  }
}
