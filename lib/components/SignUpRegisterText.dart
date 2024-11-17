// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SignUpText extends StatelessWidget {
  final String text1;
  final String text2;
  final void Function() onPressed;
  const SignUpText(this.text1, this.text2, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text1,
          style: TextStyle(color: Colors.grey[400]),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            text2,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
