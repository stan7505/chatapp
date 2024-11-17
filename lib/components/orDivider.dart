// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[400],
            thickness: 1,
            indent: 50,
            endIndent: 10,
          ),
        ),
        Text(
          text,
          style: TextStyle(color: Colors.grey[400]),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[400],
            thickness: 1,
            indent: 10,
            endIndent: 50,
          ),
        ),
      ],
    );
  }
}
