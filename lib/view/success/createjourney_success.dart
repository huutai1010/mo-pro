import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/main_app.dart';

import '../../res/colors/app_color.dart';
import 'package:flutter/material.dart';

class CreateJourneySuccessfulView extends StatelessWidget {
  const CreateJourneySuccessfulView({super.key});

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
          Text(
            context.tr('create_journey_successfully'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainApp(),
                ),
                (route) => false,
              );
            },
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
