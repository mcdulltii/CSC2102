import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/text_fields/custom_textfield.dart';
import '../../theme/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 100),
        width: AppTheme.screenWidth(context),
        child: Column(
          children: [
            const Text(
              "Login Here",
              style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: AppTheme.titleFontSize),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Welcome back you've",
              style: TextStyle(
                fontSize: AppTheme.subHeading2Size,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              "been missed!",
              style: TextStyle(
                fontSize: AppTheme.subHeading2Size,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            const CustomTextField(
              isReadyOnly: false,
              textHint: "Email",
              inputIcon: Icon(
                CupertinoIcons.mail_solid,
                color: AppTheme.hintTextColor,
              ),
              borderColor: AppTheme.hintTextColor,
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomTextField(
              isReadyOnly: false,
              textHint: "Password",
              isPassword: true,
              borderColor: AppTheme.hintTextColor,
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Forget your password?",
                  style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: AppTheme.marginOnSides,
                )
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: () {
                debugPrint("Login called");
              },
              child: Container(
                height: 60,
                width: 350,
                decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: const Center(
                    child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppTheme.subHeading3Size),
                )),
              ),
            )
          ],
        ),
      )),
    );
  }
}
