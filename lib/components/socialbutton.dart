import 'dart:ui';
import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final void Function() onTap;
  final String assetPath;
  final String text;

  const SocialLoginButton(
      {super.key,
      required this.assetPath,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: 135,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(assetPath, width: 20, height: 20),
                ),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//MODIFIABLE
class SocialLoginButtons extends StatelessWidget {
  final void Function() onTap1;
  final void Function() onTap2;

  const SocialLoginButtons(
      {super.key, required this.onTap1, required this.onTap2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton(
          onTap: onTap1,
          assetPath: 'lib/assets/google.png',
          text: 'GOOGLE',
        ),
        const SizedBox(width: 20),
        SocialLoginButton(
          onTap: onTap2,
          assetPath: 'lib/assets/apple.png',
          text: 'APPLE',
        ),
      ],
    );
  }
}
