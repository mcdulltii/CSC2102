import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/auth/pages/welcome_page.dart';
import 'package:frontend/presentation/screens/chat/pages/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StarterPage extends StatelessWidget {
  const StarterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkUserIdInSharedPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While checking the userId, display a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurs during checking, display an error message
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // If userId exists in SharedPreferences, navigate to ChatPage
          if (snapshot.data == true) {
            return const ChatPage();
          } else {
            // If userId doesn't exist in SharedPreferences, navigate to WelcomePage
            return const WelcomePage();
          }
        }
      },
    );
  }

  Future<bool> checkUserIdInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    return userId != null;
  }
}
