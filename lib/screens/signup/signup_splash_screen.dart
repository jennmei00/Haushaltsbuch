import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/screens/signup/login_screen.dart';
import 'package:haushaltsbuch/services/auth_provider.dart';
import 'package:provider/provider.dart';

class SignupSplashScreen extends StatefulWidget {
  final String userName;
  const SignupSplashScreen({super.key, required this.userName});

  static final routeName = '/signup_splash_screen';

  @override
  State<SignupSplashScreen> createState() => _SignupSplashScreenState();
}

class _SignupSplashScreenState extends State<SignupSplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    print(authProvider.currentUser);

    return authProvider.currentUser == null
        ? LoginScreen(userName: widget.userName)
        : HomeScreen(user: authProvider.currentUser);
  }
}
