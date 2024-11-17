import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/CustomTextfield.dart';
import '../../components/SignUpRegisterText.dart';
import '../../components/custombutton.dart';
import '../../components/orDivider.dart';
import '../../components/socialbutton.dart';
import '../../utility/errorhandling.dart';
import '../GoogleSignin/googleauth.dart';

class LoginPage extends StatefulWidget {
  final void Function() toggle;
  const LoginPage({
    super.key,
    required this.toggle,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final String error;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isHidden = true;

  void toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void singinUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
        });
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = AuthErrorHandler.getErrorMessage(e.code);
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[400]!.withOpacity(0.3),
            title: const Text('Error', style: TextStyle(color: Colors.white)),
            content: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'lib/assets/background.jpeg',
          color: Colors.grey.withOpacity(1),
          colorBlendMode: BlendMode.darken,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Icon(Icons.account_circle,
                        size: 100, color: Colors.grey[400]),
                    const SizedBox(height: 10),
                    const Text(
                      'Enter your login information',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CustomTextField(
                        controller: emailController,
                        icon: Icons.email,
                        hintText: 'Enter your email',
                        obscureText: false,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      child: CustomTextField(
                        controller: passwordController,
                        icon: Icons.lock,
                        hintText: 'Enter your password',
                        obscureText: _isHidden,
                        toggleVisibility: toggleVisibility,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: CustomButton(
                        text: 'LOGIN',
                        onTap: singinUser,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const DividerWithText(text: 'OR'),
                    const SizedBox(height: 50),
                    SocialLoginButtons(
                      onTap1: GoogleAuth().signinwithGoogle,
                      onTap2: () {},
                    ),
                    const SizedBox(height: 20),
                    SignUpText(
                      'Don\'t have an account?',
                      'Sign Up',
                      widget.toggle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
