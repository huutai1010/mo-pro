import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/language.dart';

class ChooseLanguageDialog extends StatelessWidget {
  const ChooseLanguageDialog({
    super.key,
    required this.accountLanguage,
    required this.appLanguage,
  });

  final Language accountLanguage;
  final Language appLanguage;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(context.tr('select_your_primary_language')),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop(accountLanguage);
          },
          child: SizedBox(
            width: 200,
            height: 50,
            child: Row(
              children: [
                Image.network(
                  accountLanguage.icon!,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  accountLanguage.name!,
                )
              ],
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop(appLanguage);
          },
          child: SizedBox(
            width: 200,
            height: 50,
            child: Row(
              children: [
                Image.network(
                  appLanguage.icon!,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  appLanguage.name!,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
