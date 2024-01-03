import 'package:flutter/material.dart';

class FormTitleText extends StatelessWidget {
  final String title;
  final bool required;
  const FormTitleText({
    required this.title,
    this.required = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            )
        ],
      ),
    );
  }
}
