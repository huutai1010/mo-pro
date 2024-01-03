import 'package:flutter/material.dart';

class AppBarActionItem extends StatelessWidget {
  final Function() onPressed;
  final Icon icon;
  const AppBarActionItem({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints(maxWidth: 35),
      onPressed: onPressed,
      icon: icon,
    );
  }
}
