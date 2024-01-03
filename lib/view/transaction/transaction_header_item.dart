import 'package:flutter/material.dart';

class TransactionHeaderItem extends StatelessWidget {
  final String content;
  final Widget icon;
  const TransactionHeaderItem({
    required this.content,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: icon),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 3,
              child: Text(
                content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.clip,
                ),
              ),
            )
          ]),
    );
  }
}
