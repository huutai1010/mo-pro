import 'package:easy_localization/easy_localization.dart';
import '../../res/colors/app_color.dart';
import '../../res/dimentions/context_size.dart';
import '../../view_model/location_access_viewmodel.dart';
import 'package:flutter/material.dart';

class ConfirmAcessLocation extends StatelessWidget {
  final LocationAccessViewModel locationAccessViewModel =
      LocationAccessViewModel();
  ConfirmAcessLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidthh = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: screenWidthh,
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth(context, percentage: .45),
              height: screenHeight * 154 / 812,
              child: Image.asset('assets/images/confirm/confirm.png'),
            ),
            SizedBox(height: screenHeight * 10 / 812),
            Text(
              context.tr('location'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: screenHeight * 15 / 812),
            Text(
              context.tr(
                  'allow_maps_to_access_your_location_while_you_use_your_app'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 20 / 812),
            GestureDetector(
              onTap: () async {
                await locationAccessViewModel.handleAccessLocation(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.primaryColor,
                ),
                alignment: Alignment.center,
                width: screenWidthh * .7,
                height: screenHeight * 50 / 812,
                child: Text(
                  context.tr('allow'),
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
                    border: Border.all(color: AppColors.primaryColor)),
                alignment: Alignment.center,
                width: screenWidthh * .7,
                height: screenHeight * 50 / 812,
                child: Text(
                  context.tr('cancel'),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
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
