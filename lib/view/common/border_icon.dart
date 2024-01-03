import 'package:flutter/material.dart';

class BorderIcon extends StatelessWidget {
  final Color backgroundColor;
  final Icon icon;
  const BorderIcon({
    required this.icon,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor,
      ),
      child: icon,
    );
  }
}
