import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/view/booking/cart_view.dart';
import 'package:etravel_mobile/view/home/list_places_view.dart';
import 'package:etravel_mobile/view/home/list_tour_view.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view/place/placedetail_view.dart';
import 'package:etravel_mobile/view/place/searchplace_view.dart';
import 'package:etravel_mobile/view_model/cart_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../models/place.dart';
import '../../models/tour.dart';
import '../../res/colors/app_color.dart';
import '../../view_model/home_viewmodel.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final int sizeForCart;
  const HomeView({required this.sizeForCart, super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var homeViewViewModel = HomeViewViewModel();
  var popularPlaces = <Place>[];
  var popularTours = <Tour>[];
  late Future<List<Place>> popularPlacesData;
  late Future<List<Tour>> popularToursData;

  @override
  void initState() {
    super.initState();
  }

  Future loadData() async {
    await homeViewViewModel
        .getPopularPlaces()
        .then((value) => popularPlaces = value);
    await homeViewViewModel
        .getPopularTours()
        .then((value) => popularTours = value);
  }

  @override
  Widget build(BuildContext context) {
    loggerInfo.i('sizeForCart = ${widget.sizeForCart}');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var cartViewModel = CartViewModel();
    return ChangeNotifierProvider<CartViewModel>(
      create: (context) => cartViewModel,
      child: FutureBuilder(
          future: loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            }
            return Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTopSection(),
                          BottomSection(
                            0,
                            cartViewModel,
                            popularTours: popularTours,
                            'Tours',
                            screenWidth,
                            screenHeight,
                            homeViewViewModel,
                          ),
                          BottomSection(
                            cartViewModel.size,
                            cartViewModel,
                            popularPlaces: popularPlaces,
                            isPopularPlace: true,
                            context.tr('places'),
                            screenWidth,
                            screenHeight,
                            homeViewViewModel,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildTopSection() {
    return SafeArea(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/background/hochiminhcity.jpg',
                ),
                colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: 280,
          ),
          Container(
            height: 260,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartView(),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white60,
                              ),
                              alignment: Alignment.center,
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                color: Color(0xFF808080),
                              ),
                            ),
                            Consumer<CartViewModel>(
                                builder: (ctx, cartViewModel, _) {
                              cartViewModel.uploadSize(widget.sizeForCart);
                              return cartViewModel.size == 0
                                  ? Container()
                                  : Positioned(
                                      top: -2,
                                      left: 23,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor,
                                        ),
                                        child: Text(
                                          '${cartViewModel.size}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                            })
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('explore_the_city_today'),
                      style: const TextStyle(
                        letterSpacing: .2,
                        fontSize: 37,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            context
                                .tr('discover_take_your_travel_to_next_level'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SearchPlaceView()));
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: 43,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white70,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              context.tr('search_place'),
                              style: TextStyle(
                                color:
                                    AppColors.searchTextColor.withOpacity(.5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.search,
                              color: Colors.black.withOpacity(.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class BottomSection extends StatelessWidget {
  int? quantity;
  CartViewModel? cartViewModel;
  String title;
  double screenWidth;
  double screenHeight;
  bool isPopularPlace;
  List<Place> popularPlaces;
  List<Tour> popularTours;
  HomeViewViewModel homeViewViewModel;

  BottomSection(
    this.quantity,
    this.cartViewModel,
    this.title,
    this.screenWidth,
    this.screenHeight,
    this.homeViewViewModel, {
    super.key,
    this.isPopularPlace = false,
    this.popularPlaces = const [],
    this.popularTours = const [],
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 20,
            bottom: 5,
          ),
          child: Row(
            children: [
              Text(
                title == 'Tours'
                    ? context.tr('popular_tours')
                    : context.tr('popular_places'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: .2,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => isPopularPlace
                        ? const ListPlacesView()
                        : const ListPopularToursView(),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Text(
                        context.tr('see_more'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                isPopularPlace ? popularPlaces.length : popularTours.length,
                (index) {
              final itemWidth = screenWidth * 200 / 375;
              final itemHeight = screenHeight * 305 / 812;
              return GestureDetector(
                onTap: () {
                  if (isPopularPlace) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailsView(
                          placeId: popularPlaces[index].id!,
                        ),
                      ),
                    );
                  } else {
                    homeViewViewModel.getTourDetailsV2(popularTours[index].id!,
                        context, isPopularPlace, context);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    left: index == 0 ? screenWidth * 20 / 375 : 0,
                    right: screenWidth * 15 / 375,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade500,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(4, 2)),
                      const BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 15,
                          spreadRadius: 1)
                    ],
                  ),
                  width: itemWidth,
                  height: itemHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  isPopularPlace
                                      ? popularPlaces[index].image!.trim()
                                      : popularTours[index].image!.trim(),
                                ),
                              ),
                            ),
                            width: itemWidth,
                            height: itemHeight * .6,
                          ),
                          (isPopularPlace ? popularPlaces[index].rate! : 0) >=
                                  4.5
                              ? Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, left: 12),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.primaryColor,
                                  ),
                                  child: Text(
                                    context.tr('eTravel\'s choice'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 10 / 375,
                          top: screenHeight * 10 / 812,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // height: 40,
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                isPopularPlace
                                    ? popularPlaces[index].name!
                                    : popularTours[index].name!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  letterSpacing: .1,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            (isPopularPlace
                                        ? popularPlaces[index].reviewsCount
                                        : popularTours[index].reviewsCount) ==
                                    0
                                ? Text(
                                    context.tr('no_reviews'),
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xFF808080)),
                                  )
                                : Row(
                                    children: [
                                      Row(
                                        children: List.generate(
                                          isPopularPlace
                                              ? popularPlaces[index]
                                                  .rate!
                                                  .toInt()
                                              : popularTours[index]
                                                  .rate!
                                                  .toInt(),
                                          (index) => Container(
                                              margin: const EdgeInsets.only(
                                                  right: 1),
                                              child: const Icon(
                                                Icons.star,
                                                size: 15,
                                                color: Color(0xFFFFB23F),
                                              )),
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '(${isPopularPlace ? popularPlaces[index].reviewsCount : popularTours[index].reviewsCount} ${context.tr('reviews')})',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF808080)),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 10),
                        child: Row(
                          children: [
                            const Spacer(),
                            Text(
                              isPopularPlace
                                  ? (popularPlaces[index].price == 0.0
                                      ? 'Free'
                                      : '\$${popularPlaces[index].price!.toStringAsFixed(1)}')
                                  : (popularTours[index].price == 0
                                      ? 'Free'
                                      : '\$${popularTours[index].price!.toStringAsFixed(1)}'),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class FavoriteLikeButton extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  bool isCheck;
  FavoriteLikeButton({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    this.isCheck = false,
  });

  @override
  State<StatefulWidget> createState() => _FavoriteLikeButtonState();
}

class _FavoriteLikeButtonState extends State<FavoriteLikeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isCheck = !widget.isCheck;
        });
      },
      child: Container(
        margin: EdgeInsets.only(
            top: widget.screenHeight * 15 / 812,
            right: widget.screenWidth * 25 / 375),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        width: widget.screenWidth * 36 / 375,
        height: widget.screenWidth * 36 / 375,
        child: Icon(
          !widget.isCheck ? Icons.favorite_border_outlined : Icons.favorite,
          color: !widget.isCheck ? Colors.black : Colors.red,
        ),
      ),
    );
  }
}
