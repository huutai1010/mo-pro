import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/view/booking/journeycurrently_view.dart';
import 'package:etravel_mobile/view/booking/journeyhasgone_view.dart';
import 'package:etravel_mobile/view/booking/journeynotgone_view.dart';
import 'package:etravel_mobile/view/booking/place_notgone_view.dart';
import 'package:etravel_mobile/view/booking/placehasgone_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WareHouseView extends StatefulWidget {
  const WareHouseView({super.key});

  @override
  State<WareHouseView> createState() => _WareHouseViewState();
}

class _WareHouseViewState extends State<WareHouseView> {
  int _selectedTab = 0;
  var _options = [];
  var _listViews = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _listViews = [
      const JourneyCurrentlyGoneView(),
      const JourneyNotGoneView(),
      const JourneyHasGoneView(),
      PlaceNotGoneView(warehouseContext: context),
      const PlaceHasGoneView(),
    ];
    _options = [
      context.tr('journey_is_go'),
      context.tr('journey_not_gone'),
      context.tr('journey_has_gone'),
      context.tr('location_not_gone'),
      context.tr('location_has_gone'),
    ];
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          context.tr('warehouse'),
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SizedBox(
        width: screenWidth,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth * .25,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          _options.length,
                          (index) => GestureDetector(
                            onTap: () {
                              _selectedTab = index;
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                color: _selectedTab == index
                                    ? AppColors.primaryColor.withOpacity(.3)
                                    : Colors.white,
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: SvgPicture.asset(
                                        'assets/images/sample/journey${index + 1}.svg',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _options[index],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  _listViews[_selectedTab],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              5,
              (index) => Container(
                margin: EdgeInsets.only(
                  top: index == 0 ? 10 : 0,
                  bottom: 10,
                  right: 10,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1592114714621-ccc6cacad26b?auto=format&fit=crop&q=80&w=2043&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      margin: const EdgeInsets.all(5),
                      width: 120,
                      height: 120,
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dinh Độc Lập',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Color(0xFF1A94FF),
                                ),
                                Text('2,5Km')
                              ],
                            ),
                            SizedBox(height: 7),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled_outlined,
                                  color: Color(0xFFFC820A),
                                ),
                                Text('1 giờ 30 phút')
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
