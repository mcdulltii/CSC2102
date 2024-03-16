import 'package:dio/dio.dart';

import 'package:frontend/logic/helper/auth_helper.dart';

import '../../../constants/api.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<void> signUp(String email, String password) async {
    try {
      final response = await _dio.post(
        '$SERVER_BASE_URL/api/addNewUser',
        data: {'userEmail': email, 'userPassword': password},
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await _dio.post(
        '$SERVER_BASE_URL/api/login',
        data: {'userEmail': email, 'userPassword': password},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final bool loginResult = responseData['result'];
        if (loginResult == true) {
          final userId = responseData['user_id'];
          await saveUserIdToLocalStorage(
              userId); // Save user_id to local storage

          String? userID = await getUserIdFromLocalStorage();
          // Use the userId
          print(userID);
        } else {
          throw Exception('Login failed: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signout() async {}
}
