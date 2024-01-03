import '../../res/colors/app_color.dart';
import 'package:flutter/material.dart';

class ConfirmTourCreateView extends StatelessWidget {
  const ConfirmTourCreateView({super.key});

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
            const Text(
              'Confirm',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: screenHeight * 15 / 812),
            const Text(
              'Do you really want to manage all \nthese places with new order',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 20 / 812),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.primaryColor,
                ),
                alignment: Alignment.center,
                width: screenWidth * .7,
                height: screenHeight * 50 / 812,
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 15 / 812),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.cancelButtonColor)),
                alignment: Alignment.center,
                width: screenWidth * .7,
                height: screenHeight * 50 / 812,
                child: Text(
                  'Cancel',
                  style: TextStyle(
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
