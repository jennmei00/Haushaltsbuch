import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/signup/signup.dart';

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
              'Registrierung',
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
                child: Padding(padding: EdgeInsets.all(20), child: Signup()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
