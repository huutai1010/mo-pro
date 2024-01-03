import 'package:etravel_mobile/const/decoration.dart';
import 'package:flutter/material.dart';

List<Widget> buildFormTextInputField({
  String title = '',
  required String name,
  required Function onSaved,
  TextInputType type = TextInputType.text,
  bool required = false,
  bool enabled = true,
  String? initialValue = '',
  bool isPassword = false,
  Function? onToggleShowPassword,
  bool isShowingPassword = false,
}) {
  return [
    if (title.isNotEmpty)
      FormInputTitle(
        title: title,
        required: required,
      ),
    TextFormField(
      keyboardType: type,
      enabled: enabled,
      initialValue: initialValue,
      obscureText: isShowingPassword,
      onSaved: (newValue) => onSaved(newValue),
      decoration: kInputDecoration.copyWith(
          contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      )),
    ),
    const SizedBox(
      height: 10,
    ),
  ];
}

class FormInputTitle extends StatelessWidget {
  const FormInputTitle({
    super.key,
    this.title = '',
    this.required = false,
  });
  final String title;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black),
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
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
