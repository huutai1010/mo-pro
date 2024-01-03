import 'package:flutter/material.dart';

import '../res/colors/app_color.dart';

var kInputDecoration = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: AppColors.searchBorderColor.withOpacity(.3),
    ),
  ),
  contentPadding: const EdgeInsets.symmetric(vertical: 10),
  hintStyle: const TextStyle(
    color: AppColors.searchBorderColor,
  ),
  suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 24),
);

var kCircularButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
  ),
);
