import 'package:etravel_mobile/const/const.dart';
import 'package:flutter/material.dart';

class CustomYesNoDialog extends StatelessWidget {
  final Icon icon;
  final String title;
  final String content;
  final String yesContent;
  final String noContent;
  final Function() onYes;
  final Function() onNo;
  const CustomYesNoDialog({
    required this.yesContent,
    required this.noContent,
    required this.title,
    required this.content,
    required this.icon,
    required this.onYes,
    required this.onNo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: kElevatedButtonDialogNoStyle,
                        onPressed: onNo,
                        child: Text(
                          noContent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: kElevatedButtonDialogYesStyle,
                        onPressed: onYes,
                        child: Text(
                          yesContent,
                        ),
                      ),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
