import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Move to /services (maybe?)
class QueryService {
  final String baseurl = "http://animaserver.duckdns.org:8080";
  final String username;
  final String password;
  final String prompt;

  QueryService(this.username, this.password, {required this.prompt});

  Future<String> queryPrompt() async {
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
