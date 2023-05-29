import 'package:flutter/material.dart';
import 'package:haushaltsbuch/services/auth_provider.dart';
import 'package:haushaltsbuch/widgets/signup/login.dart';
import 'package:haushaltsbuch/widgets/signup/security_question.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final String userName;

  const LoginScreen({super.key, required this.userName});
  static final routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userPasswordController = TextEditingController();
  final _formKeyLogin = GlobalKey<FormState>();
  AuthProvider? authProvider;

  _forgotPasswordPressed() {}

  _loginPressed() {
    if (_formKeyLogin.currentState!.validate()) {
      authProvider?.loginUser(userPasswordController.text).then((value) =>
          !value
              ? ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('wrong-password'.i18n())))
              : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              child: SvgPicture.asset('assets/images/logo_signup.svg'),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              '${'hello'.i18n()} ${widget.userName}',
              style: themeData.textTheme.headlineLarge
                  ?.copyWith(color: themeData.primaryColor, letterSpacing: 2),
            ),
            Text(
              'login-text'.i18n(),
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
                    // child: SecurityQuestion(),
                    child: Login(
                      userPasswordController: userPasswordController,
                      loginPressed: _loginPressed,
                      forgotPasswordPressed: _forgotPasswordPressed,
                      formKey: _formKeyLogin,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
