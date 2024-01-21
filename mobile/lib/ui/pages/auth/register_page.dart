import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/text_fields/custom_textfield.dart';
import '../../theme/theme.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
              "Register Here",
              style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: AppTheme.titleFontSize),
            ),
            const SizedBox(
              height: 100,
            ),
            const CustomTextField(
              isReadyOnly: false,
              textHint: "Name",
              inputIcon: Icon(
                Icons.person,
                color: AppTheme.hintTextColor,
              ),
              borderColor: AppTheme.hintTextColor,
            ),
            const SizedBox(
              height: 10,
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
              height: 10,
            ),
            const CustomTextField(
              isReadyOnly: false,
              textHint: "Password",
              isPassword: true,
              borderColor: AppTheme.hintTextColor,
              inputIcon: Icon(
                Icons.lock,
                color: AppTheme.hintTextColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomTextField(
              isReadyOnly: false,
              textHint: "Confirm Password",
              isPassword: true,
              borderColor: AppTheme.hintTextColor,
              inputIcon: Icon(
                Icons.lock,
                color: AppTheme.hintTextColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Already registered?",
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
                debugPrint("Signup called");
              },
              child: Container(
                height: 60,
                width: 350,
                decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: const Center(
                    child: Text(
                  "SIGN UP",
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
