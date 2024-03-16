import 'dart:convert';

import 'package:frontend/constants/api.dart';
import 'package:frontend/data/model/chat.dart';

import 'package:http/http.dart' as http;

class ChatRepository {
  final String botUrl = BOT_BASE_URL;

  Future<List<Chat>> retrieveChats(String userId) async {
    try {
      final response =
          await http.get(Uri.parse("$botUrl/api/getAllChats?userId=$userId"));

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as List;

        return body.map((dynamic json) {
          final map = json as Map<String, dynamic>;

          return Chat(
              id: map["chatId"] as String,
              userId: map["userId"] as String,
              title: map["title"] as String,
              timestamp: DateTime.parse(map["timestamp"]));
        }).toList();
      }
    } catch (e) {
      throw Exception("Error fetching chats: $e");
    }

    return [];
  }

  Future<void> createChat(Chat chat) async {
    try {
      final response =
          await http.post(Uri.parse("$SERVER_BASE_URL/api/addNewChat"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(chat.toJson()));


      if (response.statusCode != 201) {
        throw Exception("Faild to create chat");
      }
    } catch (e) {
      throw Exception("Error creating chat: $e");
    }
  }

  Future<void> updateChat(Chat chat) async {
    try {
      final response =
          await http.put(Uri.parse("$SERVER_BASE_URL/api/updateChatTitle"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(chat.toJson()));


      if (response.statusCode != 200) {
        throw Exception("Faild to update chat");
      }
    } catch (e) {
      throw Exception("Error updating chat: $e");
    }
  }

  Future<void> deleteChat(String id) async {
    try {
      final response = await http
          .delete(Uri.parse("$SERVER_BASE_URL/api/deleteChat?chatId=$id"));


      if (response.statusCode != 200) {
        throw Exception("Failed to delete chat");
      }
    } catch (e) {
      throw Exception("Error deleting chat: $e");
    }
  }
}
