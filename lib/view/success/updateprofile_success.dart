import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:flutter/material.dart';

class UpdateProfileSuccessfulView extends StatelessWidget {
  const UpdateProfileSuccessfulView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Spacer(),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/success/success.png'),
              ),
            ),
            width: screenWidth * 106 / 375,
            height: screenWidth * 106 / 375,
          ),
          SizedBox(height: screenHeight * 15 / 812),
          const Text(
            'Update profile successully',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          GestureDetector(
            child: Container(
              width: screenWidth * .75,
              height: screenHeight * 50 / 812,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: screenHeight * 50 / 812),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.primaryColor,
              ),
              child: Text(
                context.tr('done').toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
