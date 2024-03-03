import 'package:flutter/material.dart';
import 'package:mobile/data/model/chat.dart';

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({super.key});

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  List<Chat> chatHistory = [
    Chat(
        id: '1', title: 'Medical Needs Appointment', createdAt: DateTime.now()),
    Chat(
        id: '2',
        title: 'Medical Needs Query String',
        createdAt: (DateTime.now()).subtract(const Duration(days: 7))),
    Chat(
        id: '3',
        title: 'Medical Needs Help Is Me',
        createdAt: (DateTime.now()).subtract(const Duration(days: 30)))
  ];

  late Map<String, List<Chat>> formatChat;

  @override
  void initState() {
    super.initState();
    formatChat = segmentChatHistory(chatHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [buildHeader(context), buildMenuItems(context)],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: ElevatedButton(
        onPressed: () {},
        child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("New Chat"),
              SizedBox(width: 20),
              Icon(Icons.post_add)
            ]),
      ));

  Widget buildMenuItems(BuildContext context) => Expanded(
        child: ListView.builder(
          itemCount: formatChat.length,
          itemBuilder: (context, index) {
            final category = formatChat.keys.elementAt(index);
            final chats = formatChat[category]!;

            return chats.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: chats.length,
                        itemBuilder: (context, index) => getRow(chats[index]),
                      ),
                    ],
                  )
                : Container();
          },
        ),
      );

  Widget getRow(Chat chat) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(chat.title)),
          const Icon(Icons.edit),
          const SizedBox(width: 10),
          const Icon(Icons.delete)
        ],
      ),
    );
  }

  Map<String, List<Chat>> segmentChatHistory(List<Chat> chatHistory) {
    Map<String, List<Chat>> segments = {
      '7 Days': [],
      '30 Days': [],
      'Older Messages': []
    };

    DateTime now = DateTime.now();

    for (Chat chat in chatHistory) {
      int daysDifference = now.difference(chat.createdAt).inDays;

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
}
