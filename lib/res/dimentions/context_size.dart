import 'package:flutter/material.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double percentage = 1}) {
  return screenSize(context).height * percentage;
}

double screenWidth(BuildContext context, {double percentage = 1}) {
  return screenSize(context).width * percentage;
}
