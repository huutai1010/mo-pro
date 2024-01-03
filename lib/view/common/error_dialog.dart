import 'package:flutter/material.dart';

import '../../data/app_exception.dart';
import '../auth/error_alert_dialog.dart';

void showErrorDialog(BuildContext ctx, AppException exception) {
  showDialog<String>(
    context: ctx,
    builder: (BuildContext context) => ErrorAlertDialog(
      error: AppException(exception.getMessage),
    ),
  );
}
