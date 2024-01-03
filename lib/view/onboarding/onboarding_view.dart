import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/view/auth/login_view.dart';
import 'package:etravel_mobile/view_model/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../main_app.dart';
import '../../res/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  @override
  State<StatefulWidget> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = PageController();
  var scrollIndex = 0;
  static const List<Map<String, String>> _intro = [
    {
      'title': 'diversity_of_services',
      'detail':
          'experience_a_variety_of_services_to_meet_all_customer_requirements'
    },
    {
      'title': 'affordability',
      'detail': 'reasonable_price_suitable_for_users_pocket'
    },
    {
      'title': 'interesting_place',
      'detail':
          'many_attractive_places_attract_a_large_number_of_domestic_and_foreign_tourists'
    },
    {
      'title': 'various_cuisine',
      'detail':
          'experience_the_life_of_the_people_with_thousands_of_delicious_dishes'
    }
  ];

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final pages = List.generate(
      _intro.length,
      (index) => Column(
        children: [
          Container(
            height: screenHeight * .68,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/onboarding/ob_${index + 1}.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 25 / 812,
          ),
          Text(
            context.tr(_intro[index]['title']!),
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: screenHeight * 25 / 812,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 60 / 375),
            child: Text(
              context.tr(_intro[index]['detail']!),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: screenWidth,
              height: screenHeight * .90,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    scrollIndex = value;
                  });
                },
                controller: controller,
                itemBuilder: (_, index) {
                  return pages[index % pages.length];
                },
              ),
            ),
            scrollIndex != (_intro.length - 1)
                ? SmoothPageIndicator(
                    controller: controller,
                    count: 4,
                    effect: const ExpandingDotsEffect(
                      expansionFactor: 4,
                      dotColor: AppColors.gray7,
                      activeDotColor: AppColors.primaryColor,
                      dotWidth: 6,
                      dotHeight: 6,
                      spacing: 5,
                    ),
                  )
                : GestureDetector(
                    onTap: _goToLogin,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primaryColor,
                      ),
                      alignment: Alignment.center,
                      width: screenWidth * .85,
                      height: screenHeight * 40 / 812,
                      child: Text(
                        context.tr('start'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
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
