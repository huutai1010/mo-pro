import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/main.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/view/booking/booking_list_view.dart';
import 'package:etravel_mobile/view/warehouse/warehouse_view.dart';
import 'package:etravel_mobile/view_model/cart_viewmodel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/svg.dart';
import 'res/colors/app_color.dart';
import 'view/home/home_view.dart';
import 'view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'view/conversation/conversation_list_view.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  int sizeForCart = 0;
  Widget _homeView = const HomeView(sizeForCart: 0);
  final _bookingView = const BookingListView();
  final _createJourneyView = const WareHouseView();
  final _conversationListView = const ConversationListView();
  final _profileView = const ProfileView();
  List<Widget> _options = [];
  final _basePath = 'assets/images/sample';

  @override
  void initState() {
    notificationService.initialize((response) =>
        notificationService.onClickNotification(navigatorKey, response));
    FirebaseMessaging.onMessage.listen((message) =>
        notificationService.handleFirebaseNotification(message, context));
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _options = [
      _homeView,
      _bookingView,
      _createJourneyView,
      _conversationListView,
      _profileView,
    ];
    var icon = [
      {
        'icon': '$_basePath/home_fill.svg',
        'label': context.tr('home'),
      },
      {'icon': '$_basePath/history3.svg', 'label': context.tr('booking')},
      {
        'icon': '$_basePath/travel2.svg',
        'label': context.tr('tracking'),
      },
      {
        'icon': '$_basePath/message3.svg',
        'label': context.tr('chat'),
      },
      {
        'icon': '$_basePath/profile3.svg',
        'label': context.tr('profile'),
      }
    ];
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: _options[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(.3),
              blurRadius: 4,
            ),
          ],
        ),
        child: BottomNavigationBar(
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          type: BottomNavigationBarType.fixed,
          items: List.generate(
            icon.length,
            (index) => BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 3),
                width: index == 2 ? 35 : 24,
                height: index == 2 ? 24 : 24,
                child: SvgPicture.asset(
                  icon[index]['icon']!,
                  // ignore: deprecated_member_use
                  color: _selectedIndex == index
                      ? (index != 2 ? AppColors.primaryColor : null)
                      : (index != 2 ? AppColors.unselectedColor : null),
                ),
              ),
              label: icon[index]['label'],
            ),
          ),
          currentIndex: _selectedIndex,
          unselectedItemColor: AppColors.unselectedColor,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          onTap: (index) async {
            if (index == 0) {
              await CartViewModel()
                  .getCartPlace()
                  .then((value) => sizeForCart = value.length);
              _homeView = HomeView(sizeForCart: sizeForCart);
              loggerInfo.i('cart size = $sizeForCart');
            }
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
