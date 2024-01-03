import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/main_app.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';

import '../../res/colors/app_color.dart';
import 'package:flutter/material.dart';

class PaymentSuccessfulView extends StatelessWidget {
  const PaymentSuccessfulView({super.key});

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
            context.tr('payment_successful'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: screenHeight * 15 / 812),
          Text(
            context.tr(
                'thanks_for_choosing_to_create_tour_we_hope_you_have_the_best_experience_in_our_city'),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (ctx) => const MainApp(),
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
                context.tr('return_to_home_screen'),
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
