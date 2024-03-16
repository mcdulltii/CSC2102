import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/data/model/chat.dart';
import 'package:frontend/data/repository/chat/chat_repository.dart';
import 'package:frontend/logic/chat/chat_bloc.dart';
import 'package:frontend/logic/chat/chat_event.dart';
import 'package:frontend/logic/chat/chat_state.dart';
import 'package:frontend/logic/helper/auth_helper.dart';
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

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc(RepositoryProvider.of<ChatRepository>(context));
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
            return const Center(child: CircularProgressIndicator());
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
                                  getRow(state, chats[index]),
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
            return Center(child: Text(state.errorMessage));
          } else {
            return Container();
          }

          return Container();
        },
      );

  Widget getRow(ChatState state, Chat chat) {
    return ListTile(
      title: Row(
        children: [
          if (state is ChatLoaded && state.id == chat.id)
            Expanded(
              child: TextField(
                controller: TextEditingController(text: chat.title),
                onSubmitted: (newTitle) {
                  _chatBloc.add(ChatUpdated(chat.copyWith(title: newTitle)));
                },
              ),
            )
          else
            Expanded(
              child: Text(chat.title),
            ),
          IconButton(
            onPressed: () {
              _chatBloc.add(ChatRetrieved(chat.id, _userId));
            },
            icon: const Icon(Icons.edit),
          ),
          const SizedBox(width: 1),
          IconButton(
            onPressed: () {
              _chatBloc.add(ChatDeleted(chat.id));
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