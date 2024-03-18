import 'package:frontend/logic/helper/chat_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserIdToLocalStorage(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_id', userId);
}

Future<String?> getUserIdFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id');
}

Future<void> removeIdsFromLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_id');
  await removeChatIdFromLocalStorage();
}
