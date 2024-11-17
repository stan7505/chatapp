// ignore_for_file: file_names

import 'dart:ui';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final VoidCallback? toggleVisibility;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.obscureText,
    this.toggleVisibility,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Colors.grey[100]!.withOpacity(0.1), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(icon, color: Colors.grey[400]),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.grey[400]),
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: hintText,
                    hintStyle:
                        TextStyle(color: Colors.grey[400]!.withOpacity(0.5)),
                  ),
                ),
              ),
              if (toggleVisibility != null)
                GestureDetector(
                  onTap: toggleVisibility,
                  child: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility),
                ),
              const SizedBox(width: 13),
            ],
          ),
        ),
      ),
    );
  }
}
