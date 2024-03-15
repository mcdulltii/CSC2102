import 'package:frontend/data/model/chat.dart';

Map<String, List<Chat>> segmentChatHistory(List<Chat> chatHistory) {
  Map<String, List<Chat>> segments = {
    '7 Days': [],
    '30 Days': [],
    'Older Messages': []
  };

  DateTime now = DateTime.now();

  for (Chat chat in chatHistory) {
    int daysDifference = now.difference(chat.timestamp).inDays;

    if (daysDifference <= 7) {
      segments['7 Days']?.add(chat);
    } else if (daysDifference <= 30) {
      segments['30 Days']?.add(chat);
    } else {
      segments['Older Messages']?.add(chat);
    }
  }

  return segments;
}
