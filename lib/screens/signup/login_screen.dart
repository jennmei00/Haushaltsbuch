import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/user.dart';
import 'package:haushaltsbuch/services/auth_provider.dart';
import 'package:haushaltsbuch/widgets/signup/forgot_password.dart';
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
  TextEditingController _userPasswordController = TextEditingController();
  TextEditingController _userSecruityAnswerController = TextEditingController();
  TextEditingController _userNewPasswordController = TextEditingController();
  TextEditingController _userRepeatNewPasswordController =
      TextEditingController();

  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySecurityAnswer = GlobalKey<FormState>();
  final _formKeyForgotPassword = GlobalKey<FormState>();

  AuthProvider? authProvider;
  bool _forgotPassword = false;
  bool _showSecurityQuestion = false;

  User? _userData;

  _forgotPasswordPressed() {
    setState(() {
      _forgotPassword = true;
      _showSecurityQuestion = true;
    });
  }

  _loginPressed() {
    if (_formKeyLogin.currentState!.validate()) {
      authProvider?.loginUser(_userPasswordController.text).then((value) =>
          !value
              ? ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('wrong-password'.i18n())))
              : null);
    }
  }

  _resetPressed() {
    if (_formKeyForgotPassword.currentState!.validate()) {
      authProvider!.updateUser(
          _userData!.copyWith(password: _userNewPasswordController.text));
      _cancelPressed();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('changed-password'.i18n())));
    }
  }

  _answerPressed() {
    if (_userSecruityAnswerController.text != _userData!.securityAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('wrong-answer'.i18n()),
      ));
    } else {
      setState(() {
        _userSecruityAnswerController.text = '';
        _showSecurityQuestion = false;
      });
    }
  }

  _cancelPressed() {
    setState(() {
      _userSecruityAnswerController.text = '';
      _userNewPasswordController.text = '';
      _userPasswordController.text = '';
      _forgotPassword = false;
      _showSecurityQuestion = false;
    });
  }

  _getUserData() async {
    _userData = await authProvider!.userData;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    authProvider = Provider.of<AuthProvider>(context);

    _getUserData();

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
              _forgotPassword && _showSecurityQuestion
                  ? 'change-security-question'.i18n()
                  : _forgotPassword && !_showSecurityQuestion
                      ? 'change-password'.i18n()
                      : 'login-text'.i18n(),
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
                  child: !_forgotPassword && !_showSecurityQuestion
                      ? Login(
                          userPasswordController: _userPasswordController,
                          loginPressed: _loginPressed,
                          forgotPasswordPressed: _forgotPasswordPressed,
                          formKey: _formKeyLogin,
                        )
                      : _showSecurityQuestion && _forgotPassword
                          ? SecurityQuestion(
                              userSecurityAnswer: _userSecruityAnswerController,
                              userSecurityQuestionIdx:
                                  _userData!.securityQuestionIndex,
                              questionChanged: null,
                              answerPressed: _answerPressed,
                              cancelPressed: _cancelPressed,
                              formKey: _formKeySecurityAnswer,
                            )
                          : ForgotPasword(
                              newPassword: _userNewPasswordController,
                              repeatNewPassword:
                                  _userRepeatNewPasswordController,
                              cancelPressed: _cancelPressed,
                              resetPressed: _resetPressed,
                              formKey: _formKeyForgotPassword,
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
