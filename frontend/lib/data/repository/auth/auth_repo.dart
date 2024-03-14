import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/constants/api.dart';

class AuthRepository {
  Future<void> signUp(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$SERVER_BASE_URL/addNewUser'),
        body: {'userEmail': email, 'userPassword': password},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$SERVER_BASE_URL/login'),
        body: {'userEmail': email, 'userPassword': password},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to sign in');
      } else {
        final responseData = json.decode(response.body);
        final userId = responseData['user_id'];
        await _saveUserIdToLocalStorage(
            userId); // Save user_id to local storage

        String? userID = await getUserIdFromLocalStorage();
        if (userID != null) {
          // Use the userId
          print("userID");
        } else {
          // User_id not found in local storage
          print("userID is not saved into Local Storage");
        }
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> _saveUserIdToLocalStorage(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  Future<String?> getUserIdFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
}
