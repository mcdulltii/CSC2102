import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:frontend/data/model/message.dart';
import 'package:frontend/logic/auth/auth_cubit.dart';
import 'package:frontend/logic/helper/auth_helper.dart';
import 'package:frontend/logic/message/message_cubit.dart';
import 'package:frontend/presentation/helpers/keyboard_dimiss.dart';
import 'package:frontend/presentation/helpers/navigate_with_transition.dart';
import 'package:frontend/presentation/screens/auth/pages/welcome_page.dart';
import 'package:frontend/presentation/screens/chat/components/drawer.dart';
import 'package:frontend/presentation/screens/chat/components/text_bubble.dart';
import 'package:frontend/presentation/screens/chat/components/type_bar.dart';
import 'package:frontend/presentation/theme/theme.dart';

import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final TextEditingController editingController;

  const ChatPage({super.key, required this.editingController});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late MessageCubit cubit;
  late AuthCubit authCubit;

  bool isChatExists = false;

  // TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    cubit = BlocProvider.of<MessageCubit>(context)..isChatSelected();
    authCubit = BlocProvider.of<AuthCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(child: BlocBuilder<MessageCubit, MessageState>(
      builder: (context, state) {
        if (state is MessageQueryLoaded) {
          cubit.isChatSelected();
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.appBarColor,
            leading: const BackButton(),
            title: const Center(
              child: Text(
                "Dr. Natasha",
                style: TextStyle(fontSize: 26),
              ),
            ),
          ),
          body: state is MessagesEmpty
              ? const Center(
                  child: Text("Please select a chat"),
                )
              : Column(
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
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: TextBubble(
                            isBot: message.isBot,
                            text: message.payload,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: state is MessageQueryLoading
                          ? const SpinKitThreeBounce(
                              color: Colors.blue,
                              size: 20.0,
                            )
                          : null,
                    ),
                    TypeBar(
                      editingController: widget.editingController,
                      submitCallback: () {
                        cubit.sendQuery(widget.editingController.text);
                        widget.editingController.clear();
                      },
                    )
                  ],
                ),
        );
      },
    ));
  }
}
