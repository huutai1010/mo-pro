import 'package:easy_localization/easy_localization.dart';
import '../../models/language.dart';
import '../../res/colors/app_color.dart';
import '../confirm/confirm_access_location.dart';
import '../../view_model/language_viewmodel.dart';
import '../../view_model/main_app_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseLanguageView extends StatefulWidget {
  final bool isFromProfile;

  const ChooseLanguageView({super.key, this.isFromProfile = false});

  @override
  State<ChooseLanguageView> createState() => _ChooseLanguageViewState();
}

class _ChooseLanguageViewState extends State<ChooseLanguageView> {
  bool _isLoading = false;
  late Future _languagesFuture;

  void onConfirm() {
    final mainAppVm = Provider.of<MainAppViewModel>(context, listen: false);
    if (mainAppVm.selectedLanguage == null) {
      return;
    }
    if (widget.isFromProfile) {
      mainAppVm.changeLanguage(context).then((value) {
        Navigator.pop(context);
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmAcessLocation(),
        ),
      );
    }
  }

  @override
  void initState() {
    final mainAppVm = Provider.of<LanguageViewModel>(context, listen: false);
    _languagesFuture = mainAppVm.getLanguages();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    _languagesFuture.then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mainAppVm = Provider.of<MainAppViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background/permission.png'),
          ),
        ),
        width: screenWidth,
        height: screenHeight,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          width: screenWidth * 320 / 375,
          height: screenHeight * 420 / 812,
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: screenHeight * 15 / 812),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/confirm/confirm.png'),
                ),
              ),
              width: screenWidth * 150 / 375,
              height: screenHeight * 110 / 812,
            ),
            SizedBox(height: screenHeight * 15 / 812),
            Text(
              context.tr('choose_language'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: screenHeight * 10 / 812),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 20 / 375),
              child: Row(
                children: [
                  Text(context.tr("i_speak")),
                  const Spacer(),
                ],
              ),
            ),
            Consumer<LanguageViewModel>(
              builder: (ctx, languagesVm, _) {
                final languages = languagesVm.languages.isNotEmpty
                    ? languagesVm.languages
                    : [
                        Language(
                          name: "English(US)",
                          icon:
                              "https://firebasestorage.googleapis.com/v0/b/capstoneetravel-d42ad.appspot.com/o/Language%2Fus.png?alt=media&token=de21fec4-fbfa-46ec-a297-4bf7fdd7ecf9&_gl=1*d4ps97*_ga*MTYyNzY2MzU2NC4xNjgyNzcwNTY2*_ga_CW55HF8NVT*MTY5NjM0MDY5NC4zMC4xLjE2OTYzNDExNjEuNTQuMC4w",
                          fileLink:
                              "https://firebasestorage.googleapis.com/v0/b/capstoneetravel-d42ad.appspot.com/o/Language%2FFileTranslate%2Fen-us.json?alt=media&token=0de300c6-facc-4878-8643-8a1898314e80",
                          languageCode: "en-us",
                          id: 6,
                        ),
                      ];
                if (_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return DropdownButton<Language>(
                  onChanged: (value) {
                    if (languages.isNotEmpty) {
                      if (value != null) {
                        mainAppVm.onLanguageSelected(ctx, value);
                      }
                    } else if (languages.isEmpty) {
                      mainAppVm.onLanguageSelected(
                        ctx,
                        Language(
                          name: "English(US)",
                          icon:
                              "https://firebasestorage.googleapis.com/v0/b/capstoneetravel-d42ad.appspot.com/o/Language%2Fus.png?alt=media&token=de21fec4-fbfa-46ec-a297-4bf7fdd7ecf9&_gl=1*d4ps97*_ga*MTYyNzY2MzU2NC4xNjgyNzcwNTY2*_ga_CW55HF8NVT*MTY5NjM0MDY5NC4zMC4xLjE2OTYzNDExNjEuNTQuMC4w",
                          fileLink:
                              "https://firebasestorage.googleapis.com/v0/b/capstoneetravel-d42ad.appspot.com/o/Language%2FFileTranslate%2Fen-us.json?alt=media&token=0de300c6-facc-4878-8643-8a1898314e80",
                          languageCode: "en-us",
                          id: 6,
                        ),
                      );
                    }
                  },
                  value: mainAppVm.selectedLanguage,
                  items: languages.isNotEmpty
                      ? List.generate(
                          languages.length,
                          (index) => DropdownMenuItem(
                            value: languages[index],
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: screenWidth * 15 / 375),
                              width: screenWidth * 256 / 375,
                              height: screenHeight * 29 / 812,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            languages[index].icon!),
                                      ),
                                    ),
                                    width: screenWidth * 17 / 375,
                                    height: screenHeight * 10 / 812,
                                  ),
                                  SizedBox(width: screenWidth * 15 / 375),
                                  Text(languages[index].name!),
                                ],
                              ),
                            ),
                          ),
                        )
                      : [
                          DropdownMenuItem(
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: screenWidth * 15 / 375),
                              width: screenWidth * 256 / 375,
                              height: screenHeight * 29 / 812,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/capstoneetravel-d42ad.appspot.com/o/Language%2Fengland_language.jpg?alt=media&token=828cd40b-68a4-4908-9472-77096b633b7a'),
                                      ),
                                    ),
                                    width: screenWidth * 17 / 375,
                                    height: screenHeight * 10 / 812,
                                  ),
                                  SizedBox(width: screenWidth * 15 / 375),
                                  const Text('English(US)'),
                                ],
                              ),
                            ),
                          )
                        ],
                );
              },
            ),
            const Spacer(),
            GestureDetector(
              onTap: onConfirm,
              child: Container(
                margin: EdgeInsets.only(bottom: screenHeight * 25 / 812),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(25)),
                width: screenWidth * 250 / 375,
                height: screenHeight * 45 / 812,
                alignment: Alignment.center,
                child: Text(
                  context.tr('continue'),
                  style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
