import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/data/model/chat.dart';
import 'package:frontend/data/repository/chat/chat_repository.dart';
import 'package:frontend/logic/chat/chat_bloc.dart';
import 'package:frontend/logic/chat/chat_event.dart';
import 'package:frontend/logic/chat/chat_state.dart';
import 'package:frontend/logic/helper/auth_helper.dart';
import 'package:frontend/logic/helper/chat_helper.dart';
import 'package:frontend/logic/message/message_cubit.dart';
import 'package:frontend/presentation/helpers/segment_chat_history.dart';

class CustomNavigationDrawer extends StatefulWidget {
  final Function signoutCallback;

  const CustomNavigationDrawer({super.key, required this.signoutCallback});

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  late String _userId;
  late final ChatBloc _chatBloc;
  late final MessageCubit _messageCubit;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc(RepositoryProvider.of<ChatRepository>(context));
    _messageCubit = BlocProvider.of<MessageCubit>(context);
    _initialize();
  }

  Future<void> _initialize() async {
    await getUserIdFromLocalStorage().then((userId) {
      _userId = userId ?? '';
      _chatBloc.add(ChatRetrieved("", _userId));
    });
  }

  @override
  void dispose() {
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context),
            buildSignOutButton(context, widget.signoutCallback),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: ElevatedButton(
          onPressed: () {
            Chat chat = Chat(
                id: "",
                userId: _userId,
                title: "Untitled Chat",
                timestamp: DateTime.now());
            _chatBloc.add(ChatCreated(chat));
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("New Chat"),
              SizedBox(width: 20),
              Icon(Icons.post_add)
            ],
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) =>
      BlocBuilder<ChatBloc, ChatState>(
        bloc: _chatBloc,
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Expanded(
                child: Center(child: CircularProgressIndicator()));
          } else if (state is ChatLoaded) {
            final chats = state.chats;
            final formatChat = segmentChatHistory(chats);

            return Expanded(
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
                              itemBuilder: (context, index) =>
                                  getRow(context, state, chats[index]),
                            ),
                          ],
                        )
                      : Container();
                },
              ),
            );
          } else if (state is ChatSuccess) {
            // reload the list of chats
            _chatBloc.add(ChatRetrieved("", _userId));
          } else if (state is ChatError) {
            return Expanded(child: Center(child: Text(state.errorMessage)));
          } else {
            return Expanded(child: Container());
          }

          return Expanded(child: Container());
        },
      );

  Widget getRow(BuildContext context, ChatState state, Chat chat) {
    return ListTile(
      title: Row(
        children: [
          if (state is ChatLoaded && state.id == chat.id)
            Expanded(
              child: TextField(
                autofocus: true,
                controller: TextEditingController(text: chat.title),
                onSubmitted: (newTitle) {
                  _chatBloc.add(ChatUpdated(chat.copyWith(title: newTitle)));
                },
                onTapOutside: (_) {
                  _chatBloc.add(ChatRetrieved("", _userId));
                },
              ),
            )
          else
            Expanded(
              child: TextButton(
                onPressed: () async {
                  await saveChatIdToLocalStorage(chat.id).then((_) {
                    _messageCubit.getMessagesByChatId(chat.id);
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  chat.title,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          IconButton(
            onPressed: () {
              _chatBloc.add(ChatRetrieved(chat.id, _userId));
            },
            icon: const Icon(Icons.edit),
          ),
          const SizedBox(width: 1),
          IconButton(
            onPressed: () async {
              await getChatIdFromLocalStorage().then((chatId) {
                if (chatId == chat.id) {
                  removeChatIdFromLocalStorage();
                }
                _chatBloc.add(ChatDeleted(chat.id));
                _messageCubit.deleteMessagesByChatId(chat.id);
                // TODO: Keep on same chat after deleting other chats that is not currently opened
                // _messageCubit.getMessagesByChatId(chat.id);
              });
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Widget buildSignOutButton(BuildContext context, Function callback) =>
      Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: ElevatedButton(
          onPressed: () => callback(),
          child: const Text('Sign Out'),
        ),
      );
}
