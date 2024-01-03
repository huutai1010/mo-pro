import 'package:easy_localization/easy_localization.dart';

import '../../res/colors/app_color.dart';
import 'package:flutter/material.dart';

class ConfirmPaymentView extends StatelessWidget {
  const ConfirmPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 175 / 375,
              height: screenHeight * 154 / 812,
              child: Image.asset('assets/images/confirm/confirm.png'),
            ),
            SizedBox(height: screenHeight * 10 / 812),
            Text(
              context.tr('confirm'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: screenHeight * 15 / 812),
            Text(
              context.tr(
                  'do_you_really_want_to_create_a_tour_with_all_these_places_and_voice_package_descriptions'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 20 / 812),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Container(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.primaryColor,
                ),
                alignment: Alignment.center,
                width: screenWidth * .7,
                height: screenHeight * 50 / 812,
                child: Text(
                  context.tr('accept_and_pay'),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 15 / 812),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.cancelButtonColor)),
                alignment: Alignment.center,
                width: screenWidth * .7,
                height: screenHeight * 50 / 812,
                child: Text(
                  context.tr('cancel'),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.cancelButtonColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
