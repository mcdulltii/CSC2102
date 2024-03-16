import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveChatIdToLocalStorage(String chatId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('chat_id', chatId);
}

Future<String?> getChatIdFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('chat_id');
}
