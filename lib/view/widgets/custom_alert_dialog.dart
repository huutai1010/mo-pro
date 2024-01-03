import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String assetImagePath;
  final String content;
  const CustomAlertDialog({
    super.key,
    required this.content,
    required this.assetImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.8),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 35,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          )),
    );
  }
}
