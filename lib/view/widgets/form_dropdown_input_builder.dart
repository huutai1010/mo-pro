import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:etravel_mobile/const/decoration.dart';
import 'package:flutter/material.dart';

import 'form_text_input_builder.dart';

List<Widget> buildFormDropdownInput<T>({
  String title = '',
  required Function onChanged,
  required Function onSaved,
  required List<T> items,
  required T value,
  bool required = false,
}) {
  return [
    if (title.isNotEmpty) FormInputTitle(title: title, required: required),
    DropdownButtonFormField2<T>(
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            item.toString(),
          ),
        );
      }).toList(),
      onChanged: (newValue) => onChanged(newValue),
      value: value,
      onSaved: (newValue) => onSaved(newValue),
      decoration: kInputDecoration,
    ),
    const SizedBox(
      height: 10,
    ),
  ];
}
