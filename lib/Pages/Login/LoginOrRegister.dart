// ignore_for_file: file_names

import 'package:chatapp/Pages/Login/registerpage.dart';
import 'package:flutter/material.dart';

import 'loginpage.dart';

class Loginorregister extends StatefulWidget {
  const Loginorregister({super.key});

  @override
  State<Loginorregister> createState() => _LoginorregisterState();
}

class _LoginorregisterState extends State<Loginorregister> {
  bool isLogin = true;

  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin == true) {
      return LoginPage(toggle: toggle);
    } else {
      return Registerpage(toggle: toggle);
    }
  }
}
