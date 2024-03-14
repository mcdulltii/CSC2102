import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/auth/components/custom_scaffold.dart';
import 'package:frontend/presentation/screens/auth/components/welcome_button.dart';
import 'package:frontend/presentation/screens/auth/pages/signin_page.dart';
import 'package:frontend/presentation/screens/auth/pages/signup_page.dart';
import 'package:frontend/presentation/theme/theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'Welcome Back!\n',
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w600,
                          )),
                      TextSpan(
                        text: '\nMedical inquiries to Dr. Bot',
                        style: TextStyle(
                          fontSize: 20,
                          // height: 0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                      child: WelcomeButton(
                    buttonText: "Sign In",
                    onTap: SignInPage(),
                    color: Colors.transparent,
                    textColor: Colors.white,
                  )),
                  Expanded(
                      child: WelcomeButton(
                    buttonText: "Sign Up",
                    onTap: const SignUpPage(),
                    color: Colors.white,
                    textColor: lightColorScheme.primary,
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
