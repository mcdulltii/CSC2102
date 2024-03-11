import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../../constants/api.dart';

class ChatRepo {
  final String baseurl = QUERY_BASE_URL;

  ChatRepo();

  Future<String> queryPrompt(String prompt) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseurl/api/getModelInf'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              // TO DO: IMPLEMENT AFTER DATABASE IS SET-UP
              // HttpHeaders.authorizationHeader: 'Basic $base64Encode(utf8.encode('$username:$password'))',
            },
            body: jsonEncode({'prompt': prompt}),
          )
          .timeout(const Duration(seconds: 5)); // Set the timeout to 5 seconds

      String returnPrompt = jsonDecode(response.body);
      return returnPrompt;
    } on TimeoutException {
      return "The request timed out. Please try again.";
    } catch (e) {
      return "I apologize, there was an error processing your query. Please try again.";
    }
  }
}
