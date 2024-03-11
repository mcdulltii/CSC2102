import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/data/model/message.dart';
import 'package:frontend/logic/chat/chat_cubit.dart';
import 'package:frontend/presentation/helpers/keyboard_dimiss.dart';
import 'package:frontend/presentation/screens/chat/components/drawer.dart';
import 'package:frontend/presentation/screens/chat/components/text_bubble.dart';
import 'package:frontend/presentation/screens/chat/components/type_bar.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatCubit cubit;

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    cubit = BlocProvider.of<ChatCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(child: BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            title: const Text(
              "Dr. Bot",
              style: TextStyle(fontSize: 26),
            ),
            actions: [
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset("assets/robot.gif"),
              )
            ],
          ),
          drawer: const CustomNavigationDrawer(),
          body: Column(
            children: [
              Expanded(
                child: GroupedListView(
                  padding: const EdgeInsets.all(10),
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  elements: cubit.messages,
                  groupBy: (message) => DateTime(message.timestamp.year,
                      message.timestamp.month, message.timestamp.day),
                  groupHeaderBuilder: (Message message) => SizedBox(
                    height: 40,
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            DateFormat.yMMMd().format(message.timestamp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, Message message) => Align(
                    alignment: message.isBot
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: TextBubble(
                      text: message.payload,
                    ),
                  ),
                ),
              ),
              Center(
                child: state is ChatQueryLoading
                    ? const SpinKitThreeBounce(
                        color: Colors.blue,
                        size: 20.0,
                      )
                    : null,
              ),
              TypeBar(
                editingController: editingController,
                submitCallback: () {
                  cubit.sendQuery(editingController.text);
                  editingController.clear();
                },
              )
            ],
          ),
        );
      },
    ));
  }
}