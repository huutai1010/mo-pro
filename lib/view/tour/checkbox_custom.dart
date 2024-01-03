import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:flutter/material.dart';

class CheckboxCustom extends StatefulWidget {
  bool state = false;
  void Function()? onTapCheckbox;
  CheckboxCustom({required this.onTapCheckbox, super.key});

  @override
  State<CheckboxCustom> createState() => _CheckboxCustomState();
}

class _CheckboxCustomState extends State<CheckboxCustom> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTapCheckbox!();
        widget.state = !widget.state;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: widget.state ? AppColors.primaryColor : Colors.white,
          border: Border.all(
            width: 1,
            color: widget.state ? AppColors.primaryColor : Colors.black,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        width: 25,
        height: 25,
        child: widget.state
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 15,
              )
            : Container(),
      ),
    );
  }
}
