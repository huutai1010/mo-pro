import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isBackground;
  const LoadingIndicator({
    this.isBackground = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isBackground) Container(color: Colors.black.withOpacity(.4)),
        Center(
          child: Lottie.asset('assets/images/auth/loading.json'),
        ),
      ],
    );
  }
}
