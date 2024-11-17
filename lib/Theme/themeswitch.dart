import 'package:chatapp/Theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Themeswitch extends StatefulWidget {
  const Themeswitch({super.key});

  @override
  State<Themeswitch> createState() => _ThemeswitchState();
}

class _ThemeswitchState extends State<Themeswitch> {
  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: Theme.of(context).brightness == Brightness.dark,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme();
      },
    );
  }
}
