import 'package:flutter/material.dart';
import 'package:restaurant/views/login/SignIn.dart';
import 'package:restaurant/views/login/SignUp.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({ Key? key }) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return isLogin ? SignInPage(onClickedSignUp: toggle) : SignUp(onClickedSignIn: toggle);
  }

  void toggle() => setState(() => isLogin = !isLogin);

}