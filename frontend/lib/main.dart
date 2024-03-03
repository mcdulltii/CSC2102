import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/chat/chat_repo.dart';
import 'package:frontend/presentation/navigation/wrapper.dart';

import 'logic/chat/chat_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DR. Bot',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => ChatRepo(),
            ),
          ],
          child: MultiBlocProvider(providers: [
            BlocProvider(
              create: (context) =>
                  ChatCubit(RepositoryProvider.of<ChatRepo>(context)),
            ),
          ], child: const Wrapper())),
    );
  }
}
