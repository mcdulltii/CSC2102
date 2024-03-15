import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/auth/auth_repo.dart';
import 'package:frontend/presentation/navigation/starter_screen.dart';
import 'package:frontend/data/repository/chat/chat_repository.dart';
import 'package:frontend/data/repository/chat/message_repository.dart';

import 'logic/auth/auth_cubit.dart';
import 'logic/message/message_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => MessageRepository()),
        RepositoryProvider(create: (context) => ChatRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AuthCubit(
                    RepositoryProvider.of<AuthRepository>(context),
                  )),
          BlocProvider(
            create: (context) => MessageCubit(
              RepositoryProvider.of<MessageRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DR. Bot',
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: const StarterPage(),
        ),
      ),
    );
  }
}
