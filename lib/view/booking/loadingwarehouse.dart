import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';

class LoadingWarehouse extends StatelessWidget {
  const LoadingWarehouse({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: Lottie.asset('assets/images/auth/myloading.json'),
          ),
          const SizedBox(height: 10),
          Text(
            context.tr('please_waiting'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
