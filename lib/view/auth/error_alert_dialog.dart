import 'package:flutter/material.dart';

import '../../data/app_exception.dart';

class ErrorAlertDialog extends StatelessWidget {
  final AppException error;
  const ErrorAlertDialog({
    required this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(error.getMessage),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
