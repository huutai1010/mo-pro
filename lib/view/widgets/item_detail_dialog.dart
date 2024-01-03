import 'package:flutter/material.dart';

class ItemDetailDialog extends StatelessWidget {
  final Widget child;
  final Function onShowSaveDialog;
  const ItemDetailDialog(
      {required this.child, required this.onShowSaveDialog, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(children: [
            GestureDetector(
              onLongPress: () => onShowSaveDialog(),
              child: child,
            ),
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ]),
        ));
  }
}
