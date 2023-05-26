import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/signup/forgot_password.dart';
import 'package:haushaltsbuch/widgets/signup/login.dart';
import 'package:haushaltsbuch/widgets/signup/security_question.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static final routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              child: Image.asset('assets/images/logo2.png'),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Hallo Jenny',
              style: themeData.textTheme.headlineLarge
                  ?.copyWith(color: themeData.primaryColor, letterSpacing: 2),
            ),
            Text(
              'Bitte melde dich an',
              style: themeData.textTheme.bodyMedium
                  ?.copyWith(color: themeData.primaryColor, letterSpacing: 2),
            ),
            SizedBox(
              height: 40,
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: themeData.primaryColor,
                        width: 4.0,
                        style: BorderStyle.solid)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SecurityQuestion(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
