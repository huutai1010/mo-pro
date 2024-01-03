import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:flutter/material.dart';

class ExceptionView extends StatefulWidget {
  void Function() onRefresh;
  ExceptionView({
    required this.onRefresh,
    super.key,
  });

  @override
  State<ExceptionView> createState() => _ExceptionViewState();
}

class _ExceptionViewState extends State<ExceptionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/background/create_journey.png'),
                  fit: BoxFit.cover,
                ),
              ),
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 15),
            const Text(
              'Opps! Something went wrong.',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Check your connection, then refresh the page.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onRefresh,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    border:
                        Border.all(width: .7, color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(25)),
                child: const Text(
                  'Refresh',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
