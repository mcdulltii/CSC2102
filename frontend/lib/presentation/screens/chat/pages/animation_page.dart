import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/logic/auth/auth_cubit.dart';
import 'package:frontend/logic/helper/auth_helper.dart';
import 'package:frontend/logic/message/message_cubit.dart';
import 'package:frontend/presentation/helpers/keyboard_dimiss.dart';
import 'package:frontend/presentation/helpers/navigate_with_transition.dart';
import 'package:frontend/presentation/screens/auth/pages/welcome_page.dart';
import 'package:frontend/presentation/screens/chat/components/animation_bubble.dart';
import 'package:frontend/presentation/screens/chat/components/drawer.dart';
import 'package:frontend/presentation/screens/chat/components/text_bubble.dart';
import 'package:frontend/presentation/screens/chat/pages/chat_page.dart';

import '../components/type_bar.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  final editingController = TextEditingController();
  late MessageCubit cubit;
  late AuthCubit authCubit;

  bool isChatExists = false;

  @override
  void initState() {
    cubit = BlocProvider.of<MessageCubit>(context)..isChatSelected();
    authCubit = BlocProvider.of<AuthCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Dr. Bot",
                style: TextStyle(fontSize: 26),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    navigateWithFadeTransition(
                        context,
                        ChatPage(
                          editingController: editingController,
                        ));
                  },
                  icon: const Icon(
                    Icons.history,
                    size: 40,
                  ),
                ),
              ],
            ),
            drawer: CustomNavigationDrawer(
              signoutCallback: () {
                // authCubit.signout;
                removeIdsFromLocalStorage();
                cubit.removeAllMessage();
                navigateWithFadeTransition(context, const WelcomePage());
              },
            ),
            body: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset("assets/robot.gif", fit: BoxFit.cover),
                  ),
                ),
                Center(
                  child: (state is MessageQueryLoaded && state.text != "") ||
                          cubit.botLastMessage != ""
                      ? AnimationBubble(
                          text: cubit.botLastMessage,
                          callback: () {
                            navigateWithFadeTransition(
                              context,
                              ChatPage(
                                editingController: editingController,
                              ),
                            );
                          },
                        )
                      : null,
                ),
                Center(
                  child: state is MessageQueryLoading
                      ? const SpinKitThreeBounce(
                          color: Colors.blue,
                          size: 20.0,
                        )
                      : null,
                ),
                Center(
                  child: TypeBar(
                    editingController: editingController,
                    submitCallback: () {
                      cubit.sendQuery(editingController.text);
                      editingController.clear();
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
