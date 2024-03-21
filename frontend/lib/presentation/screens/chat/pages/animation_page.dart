import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/logic/auth/auth_cubit.dart';
import 'package:frontend/logic/helper/auth_helper.dart';
import 'package:frontend/logic/message/message_cubit.dart';
import 'package:frontend/logic/tts/tts_cubit.dart';
import 'package:frontend/presentation/helpers/keyboard_dimiss.dart';
import 'package:frontend/presentation/helpers/navigate_with_transition.dart';
import 'package:frontend/presentation/screens/auth/pages/welcome_page.dart';
import 'package:frontend/presentation/screens/chat/components/animation_bubble.dart';
import 'package:frontend/presentation/screens/chat/components/drawer.dart';
import 'package:frontend/presentation/screens/chat/components/text_bubble.dart';
import 'package:frontend/presentation/screens/chat/pages/chat_page.dart';
import 'package:frontend/presentation/theme/theme.dart';

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
  late TTSManager ttsCubit = TTSManager();

  bool isChatExists = false;
  bool isSpeaking = false;

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
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: AppTheme.appBarColor,
              title: const Center(
                child: Text(
                  "Dr. Natasha",
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
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
                  child: GestureDetector(
                    onTap: () {
                      if (cubit.botLastMessage.isNotEmpty) {
                        
                        setState(() {
                          if((state as MessageQueryLoaded).isSpeaking){
                            state.isSpeaking=false;
                          }else{
                            state.isSpeaking=true;
                          }
                          ttsCubit.setIsSpeaking(state.isSpeaking);
                        });
                        ttsCubit.speak(cubit
                            .botLastMessage);
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        state is MessageQueryLoaded && state.isSpeaking
                          ? "assets/doctor_talking.gif"
                          : "assets/doctor.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: (state is MessageQueryLoaded)
                      ? Container(
                          child: cubit.botLastMessage == ""
                              ? null
                              : AnimationBubble(
                                  text: state.text,
                                  callback: () {
                                    navigateWithFadeTransition(
                                      context,
                                      ChatPage(
                                        editingController: editingController,
                                      ),
                                    );
                                  },
                                ),
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
