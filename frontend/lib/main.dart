import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/auth/auth_repo.dart';
import 'package:frontend/data/repository/chat/chat_repo.dart';
import 'package:frontend/presentation/screens/auth/pages/welcome_page.dart';

import 'logic/auth/auth_cubit.dart';
import 'logic/chat/chat_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ChatRepo(),
        ),
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ChatCubit(
              RepositoryProvider.of<ChatRepo>(context),
            ),
          ),
          BlocProvider(
            create: (context) => AuthCubit(
              RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DR. Bot',
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: const WelcomePage(),
        ),
      ),
    );
  }
}
