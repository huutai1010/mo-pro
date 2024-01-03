import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInputView extends StatefulWidget {
  const OTPInputView({super.key});

  @override
  State<OTPInputView> createState() => _OTPInputViewState();
}

class _OTPInputViewState extends State<OTPInputView> {
  final _form = GlobalKey<FormState>();
  final List<String> _otp = ['', '', '', '', '', ''];

  void _onSubmit() {
    _form.currentState?.save();
    String otpData = _otp.join('');
    Navigator.of(context).pop(otpData);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(),
        Column(
          children: [
            Text(
              context.tr('verify_your_phone_number'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              context.tr('we_sent_otp_code_to_your_phone'),
              style: const TextStyle(color: AppColors.shadowColor),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          context.tr('enter_your_code'),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Form(
          key: _form,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              6,
              (index) => Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: TextFormField(
                  initialValue: _otp[index],
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  onSaved: (value) {
                    if (value != null) {
                      _otp[index] = value;
                    }
                  },
                  style: Theme.of(context).textTheme.headline6,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.otpColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _onSubmit(),
          child: Container(
            margin: EdgeInsets.only(bottom: screenHeight * 50 / 812),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryColor,
            ),
            width: screenWidth * 343 / 375,
            height: screenHeight * 48 / 812,
            alignment: Alignment.center,
            child: Text(
              context.tr('continue'),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
