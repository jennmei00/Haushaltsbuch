import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haushaltsbuch/screens/start_screen.dart';
import 'package:haushaltsbuch/services/auth_provider.dart';
import 'package:haushaltsbuch/widgets/signup/security_question.dart';
import 'package:haushaltsbuch/widgets/signup/signup.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static final routeName = '/signup_screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userRepeatPasswordController = TextEditingController();
  final _formKeyRegister = GlobalKey<FormState>();
  bool _showSecurityQuestion = false;
  final _formKeyQuestion = GlobalKey<FormState>();
  TextEditingController userSecurityAnswer = TextEditingController();
  int userSecurityQuestionIdx = 0;

  _registerPressed() async {
    if (_formKeyRegister.currentState!.validate()) {
      setState(() {
        _showSecurityQuestion = true;
      });
    }
  }

  _answerPressed() async {
    if (_formKeyQuestion.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loginActivated', true);
      await prefs.setString('userName', userNameController.text);

      await AuthProvider().registerUser(
        userNameController.text,
        userPasswordController.text,
        userSecurityQuestionIdx,
        userSecurityAnswer.text,
      );

      Navigator.of(context).pushNamed(StartScreen.routeName);
    }
  }

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
              child: SvgPicture.asset(
                'assets/images/logo_signup.svg',
                colorFilter: ColorFilter.mode(
                    themeData.textTheme.bodyLarge!.color!, BlendMode.srcIn),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              !_showSecurityQuestion
                  ? 'title-register'.i18n()
                  : 'select-security-question'.i18n(),
              style: themeData.textTheme.headlineLarge
                  ?.copyWith(color: themeData.primaryColor, letterSpacing: 2),
            ),
            SizedBox(
              height: 50,
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
                  child: !_showSecurityQuestion
                      ? Signup(
                          registerPressed: _registerPressed,
                          userNameController: userNameController,
                          userPasswordController: userPasswordController,
                          userRepeatPasswordController:
                              userRepeatPasswordController,
                          formKey: _formKeyRegister,
                        )
                      : SecurityQuestion(
                          cancelPressed: () {
                            setState(() {
                              _showSecurityQuestion = false;
                            });
                          },
                          questionChanged: (int val) {
                            setState(() {
                              userSecurityQuestionIdx = val;
                            });
                          },
                          userSecurityAnswer: userSecurityAnswer,
                          userSecurityQuestionIdx: userSecurityQuestionIdx,
                          answerPressed: _answerPressed,
                          formKey: _formKeyQuestion,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
