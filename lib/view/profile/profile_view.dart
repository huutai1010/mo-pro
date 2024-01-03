import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/profile_viewmodel.dart';
import 'edit_profile_view.dart';
import '../transaction/transactions_view.dart';
import '../../models/account.dart';
import '../../res/colors/app_color.dart';
import '../../services/local_storage_service.dart';
import '../language/choose_language_view.dart';
import '../place/favoriteplace_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final profileVm = Provider.of<ProfileViewModel>(context);

    TextStyle itemStyle = const TextStyle(
      fontSize: 17,
    );

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 25 / 375,
              vertical: screenHeight * 40 / 812),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FutureBuilder<Account?>(
              future: LocalStorageService().getAccount(),
              builder: (ctx, snapshot) {
                final accountData = snapshot.data;
                return Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            accountData?.image ??
                                'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXZhdGFyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60',
                          ),
                        ),
                      ),
                      width: screenWidth * 70 / 375,
                      height: screenWidth * 70 / 375,
                    ),
                    SizedBox(width: screenWidth * 15 / 275),
                    if (accountData != null)
                      Text(
                        '${accountData.firstName} ${accountData.lastName}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: screenHeight * 15 / 812),
            const Divider(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoritePlaceView(),
                  ),
                );
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: screenHeight * 10 / 812),
                child: Row(
                  children: [
                    Text(
                      context.tr('favourite_places'),
                      style: itemStyle,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 20 / 812),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const TransactionsView(),
                ));
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: screenHeight * 10 / 812),
                child: Row(
                  children: [
                    Text(
                      context.tr('transactions'),
                      style: itemStyle,
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_outlined, size: 18)
                  ],
                ),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const TransactionsView(),
                ));
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: screenHeight * 10 / 812),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      context.tr('allow_search'),
                      style: itemStyle,
                    ),
                    const Spacer(),
                    Switch(
                      value: profileVm.allowSearch,
                      onChanged: (value) =>
                          profileVm.toggleSearch(context, value),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 20 / 812),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 5 / 812),
              child: Text(
                context.tr('account_setting'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: screenHeight * 10 / 812),
            GestureDetector(
              onTap: () {
                try {
                  LocalStorageService().getAccount().then((value) {
                    return Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => EditProfileView(profile: value!),
                      ),
                    );
                  }).then((success) {
                    if (success ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(context.tr('update_succeeded')),
                        ),
                      );
                      setState(() {});
                    }
                  });
                } catch (e) {
                  print(e);
                }
              },
              child: ArrowBorderButton(
                  title: context.tr('edit_profile'),
                  icon: Icons.person_2_outlined,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight),
            ),
            SizedBox(height: screenHeight * 20 / 812),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ChooseLanguageView(isFromProfile: true),
                  ),
                );
              },
              child: ArrowBorderButton(
                title: context.tr('change_language'),
                icon: Icons.language,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
            SizedBox(height: screenHeight * 20 / 812),
            ArrowBorderButton(
                title: context.tr('color_mode'),
                icon: Icons.sunny_snowing,
                screenWidth: screenWidth,
                screenHeight: screenHeight),
            SizedBox(height: screenHeight * 20 / 812),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 5 / 812),
              child: Text(
                context.tr('legal'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: screenHeight * 20 / 812),
            BorderButton(
                title: context.tr('terms_and_condition'),
                icon: Icons.terminal,
                screenWidth: screenWidth,
                screenHeight: screenHeight),
            SizedBox(height: screenHeight * 20 / 812),
            BorderButton(
                title: context.tr('privacy_policy'),
                icon: Icons.privacy_tip,
                screenWidth: screenWidth,
                screenHeight: screenHeight),
            SizedBox(height: screenHeight * 20 / 812),
            GestureDetector(
              onTap: () async {
                await profileVm.logout(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.primaryColor,
                ),
                width: screenWidth * 323 / 375,
                height: screenHeight * 58 / 812,
                alignment: Alignment.center,
                child: Text(
                  context.tr('logout'),
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ]),
        ),
      )),
    );
  }
}

class ArrowBorderButton extends StatelessWidget {
  final String title;
  final IconData icon;
  const ArrowBorderButton({
    required this.title,
    required this.icon,
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 10 / 375),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(.1)),
        borderRadius: BorderRadius.circular(15),
      ),
      width: screenWidth,
      height: screenHeight * 60 / 812,
      child: Row(children: [
        Icon(icon),
        SizedBox(
          width: screenWidth * 5 / 375,
        ),
        Text(title, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        const Icon(
          Icons.arrow_forward_ios_sharp,
          size: 18,
        ),
      ]),
    );
  }
}

class BorderButton extends StatelessWidget {
  final String title;
  final IconData icon;
  const BorderButton({
    required this.title,
    required this.icon,
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 10 / 375),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(.1)),
        borderRadius: BorderRadius.circular(15),
      ),
      width: screenWidth,
      height: screenHeight * 60 / 812,
      child: Row(children: [
        Icon(icon),
        SizedBox(
          width: screenWidth * 5 / 375,
        ),
        Text(title, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        // const Icon(
        //   Icons.arrow_forward_ios_sharp,
        //   size: 18,
        // ),
      ]),
    );
  }
}
