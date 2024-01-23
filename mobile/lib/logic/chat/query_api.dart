import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class QueryService {
  final String baseurl = "http://animaserver.duckdns.org:8080";
  final String username;
  final String password;
  // final String prompt;

  QueryService({required this.username, required this.password});

  Future<String> queryPrompt(String prompt) async {
    final http.Response response;
    try {
      response = await http.post(
        Uri.parse('$baseurl/api/getModelInf'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          // TO DO: IMPLEMENT AFTER DATABASE IS SET-UP
          // HttpHeaders.authorizationHeader: 'Basic $base64Encode(utf8.encode('$username:$password'))',
        },
        body: jsonEncode({'prompt': prompt}),
      );
    } catch (e) {
      return "I apologize, there was an error processing your query. Please try again.";
    }
    String returnPrompt = jsonDecode(response.body);
    return returnPrompt;
  }
}

// Sample usage
void prompt() async {
  String prompt = "What is diabetes?"; // Switch w user_input
  QueryService prompter = QueryService(
      username: "Alice",
      password: "Bob"); // Switch w username and password for credentials
  String botResponse = await prompter.queryPrompt(prompt);
  print(botResponse);
}
