import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:mobile/ui/pages/chat/components/bot_reply.dart';

import 'components/user_query.dart';

class Message {
  final DateTime date;
  final Widget widget;

  Message({required this.date, required this.widget});
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [
    Message(
      date: DateTime.now().subtract(const Duration(seconds: 1)),
      widget: const UserQuery(
        text: "Having migraines. What should I do?",
      ),
    ),
    Message(
      date: DateTime.now().subtract(const Duration(seconds: 2)),
      widget: const BotReply(
        text:
            "Ensure you get an adequate amount of quality sleep. Establish a consistent sleep routine by going to bed and waking up at the same time every day",
      ),
    ),
    Message(
      date: DateTime.now().subtract(const Duration(seconds: 1)),
      widget: const UserQuery(
        text: "having shoulder pain. any prescriptions?",
      ),
    ),
    Message(
      date: DateTime.now().subtract(const Duration(seconds: 2)),
      widget: const BotReply(
        text:
            "Give your shoulder time to rest and avoid activities that may aggravate the pain. Rest does not mean complete inactivity, but rather avoiding activities that worsen the pain.",
      ),
    ),
    Message(
      date: DateTime.now().subtract(const Duration(seconds: 1)),
      widget: const UserQuery(
        text: "How much sleep does an adult need",
      ),
    ),
    Message(
      date: DateTime.now().subtract(const Duration(seconds: 2)),
      widget: const BotReply(
        text:
            "- Young Adults (18-25 years): 7-9 hours per night\n- Adults (26-64 years): 7-9 hours per night\n- Older Adults (65 years and older): 7-8 hours per night",
      ),
    ),
  ];

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Dr Bot",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: GroupedListView<Message, DateTime>(
                    reverse: true,
                    order: GroupedListOrder.DESC,
                    useStickyGroupSeparators: true,
                    floatingHeader: true,
                    elements: messages,
                    groupBy: (message) => DateTime(message.date.year,
                        message.date.month, message.date.day),
                    groupHeaderBuilder: (Message message) => SizedBox(
                      height: 40,
                      child: Center(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child:
                                Text(DateFormat.yMMMd().format(message.date)),
                          ),
                        ),
                      ),
                    ),
                    itemBuilder: (context, Message message) => message.widget,
                  ),
                ),
                TextBar()
              ],
            ),
          )),
    );
  }

  Widget TextBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color with opacity
            spreadRadius: 0, // Spread radius
            blurRadius: 10, // Blur radius
            offset: const Offset(
                0, 4), // changes position of shadow, x-axis and y-axis
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: "Send a message",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final message = Message(
                date: DateTime.now(),
                widget: UserQuery(text: _textEditingController.text),
              );
              setState(() {
                messages.add(message);
              });
              _textEditingController.clear();

              //
            },
          ),
        ],
      ),
    );
  }
}
