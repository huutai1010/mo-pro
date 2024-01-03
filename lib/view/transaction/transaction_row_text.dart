import 'package:flutter/material.dart';

import '../../const/const.dart';

class RowText extends StatelessWidget {
  final String content;
  final TextOverflow overflow;

  const RowText(
    this.content, {
    super.key,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      textAlign: TextAlign.right,
      overflow: overflow,
      style: titleTextStyle,
    );
  }
}
