import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/feedback.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/models/place_image.dart';
import 'package:etravel_mobile/repository/place_repository.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/view/booking/cart_view.dart';
import 'package:etravel_mobile/view/exception/exception_view.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view/success/change_currency_popup.dart';
import 'package:etravel_mobile/view_model/place_detail_viewmodel.dart';
import 'package:etravel_mobile/view_model/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hidable/hidable.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../const/const.dart';
import '../widgets/feedback_list.dart';

// ignore: must_be_immutable
class PlaceDetailsView extends StatefulWidget {
  int placeId;
  PlaceDetailsView({
    required this.placeId,
    super.key,
  });

  @override
  State<PlaceDetailsView> createState() => _PlaceDetailsViewState();
}

class _PlaceDetailsViewState extends State<PlaceDetailsView> {
  double _exchangePrice = 0;
  int _exchangeIndex = 0;
  bool isBooked = false;
  late List<Place> placesAround = [];

  final Completer<GoogleMapController> _controller = Completer();
  final ScrollController scrollController = ScrollController();
  final PageController controller = PageController();
  final PlaceDetailViewModel placeDetailViewModel = PlaceDetailViewModel();
  late Future loadData;
  late Future<Place?> placeData;
  late Future<bool> isBookingItemData;
  List<Map<String, dynamic>> beacons = [];
  late Place place;
  int pageValue = 0;
  var style1 = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  var style2 = const TextStyle(color: AppColors.placeDetailTitleColor);
  var style4 = const TextStyle(fontSize: 10, color: AppColors.grayTextColor);
  var style5 = const TextStyle(fontWeight: FontWeight.bold);
  var style6 = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  var space1 = const SizedBox(height: 5);
  var space2 = const SizedBox(height: 20);
  var space3 = const SizedBox(height: 10);
  var style3 = const TextStyle(
    fontSize: 12,
    color: AppColors.placeDetailTitleColor,
  );
  var style8 = const TextStyle(
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );
  var style9 = const TextStyle(color: AppColors.primaryColor, fontSize: 12);

  void _toggleFavorite(int placeId) async {
    await PlaceRepository().postFavoritePlace(placeId);
    setState(() {
      place.isFavorite = !(place.isFavorite ?? false);
    });
  }

  @override
  void initState() {
    loadData = loadPlaceData();
    super.initState();
  }

  void _onCurrencyChange(int selectedExchangeIndex) {
    setState(() {
      _exchangeIndex = selectedExchangeIndex;
      if (_exchangeIndex != 0) {
        _exchangePrice =
            place.exchanges![kCurrencies[selectedExchangeIndex]['key']]!;
      }
    });
  }

  Future loadPlaceData() async {
    await placeDetailViewModel
        .getPlaceDetails(widget.placeId, context)
        .then((value) async {
      if (value != null) {
        place = value;
        await SearchViewModel()
            .getPlacesAroundSelectedPlace(widget.placeId)
            .then((recommentPlace) {
          placesAround = recommentPlace;
        });
      }
    });
    await placeDetailViewModel
        .isBookingPlace(widget.placeId)
        .then((value) => isBooked = value);

    await placeDetailViewModel
        .getListBeaconsAtPlace(widget.placeId)
        .then((value) => beacons = value);
    await placeDetailViewModel.getQuantity();
    await placeDetailViewModel.loadMarkerData(place);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaceDetailViewModel>(
      create: (context) => placeDetailViewModel,
      child: Consumer<PlaceDetailViewModel>(
        builder: (context, vm, _) {
          return vm.isFailed
              ? ExceptionView(onRefresh: () {
                  vm.setFailed(false);
                  setState(() {});
                })
              : Scaffold(
                  body: FutureBuilder(
                    future: loadData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingView();
                      } else {
                        return Stack(
                          children: [
                            CustomScrollView(
                              controller: scrollController,
                              slivers: [
                                _buildAppBar(
                                  context,
                                  place.placeImages!,
                                  place.isFavorite ?? false,
                                  () => _toggleFavorite(place.id!),
                                  (selectedIndex) =>
                                      _onCurrencyChange(selectedIndex),
                                ),
                                _buildPlaceInfos(
                                  place.name!,
                                  place.entryTicket!,
                                  place.description!,
                                  place.openTime!,
                                  place.endTime!,
                                  place.rate ?? 0.0,
                                  place.feedBacks!,
                                  placeDetailViewModel.markers,
                                  beacons,
                                ),
                                FeedbackList(
                                  feedbacks: place.feedBacks ?? [],
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    childCount: 1,
                                    (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(context.tr('Recommend'),
                                                style: style6),
                                          ),
                                          const SizedBox(height: 20),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children:
                                                  List.generate(5, (index) {
                                                return GestureDetector(
                                                  child:
                                                      _buildPlacesRecommended(),
                                                );
                                              }),
                                            ),
                                          ),
                                          const SizedBox(height: 40),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                            _buildBookingButton(
                              place.price!,
                              _exchangePrice,
                              _exchangeIndex,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                );
        },
      ),
    );
  }

  Widget _buildPlacesRecommended() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          placesAround.length,
          (index) => GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PlaceDetailsView(placeId: placesAround[index].id!),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(left: index == 0 ? 20 : 0, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: .2),
              ),
              width: 170,
              height: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      image: DecorationImage(
                        image: NetworkImage(placesAround[index].image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 170,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      placesAround[index].name!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: placesAround[index].rate == 0.0
                        ? Text(
                            context.tr('no_reviews'),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          )
                        : Row(
                            children: [
                              Row(
                                children: List.generate(
                                  placesAround[index].rate!.toInt(),
                                  (index) => Container(
                                    margin: const EdgeInsets.only(right: 1),
                                    child: const Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFFFFB23F),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '(${placesAround[index].reviewsCount} ${context.tr('reviews')})',
                                style: const TextStyle(
                                    fontSize: 10, color: Color(0xFF808080)),
                              ),
                            ],
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        const Spacer(),
                        Text(
                          '\$${placesAround[index].price}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(.6),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // return const Expanded(
  //     child: Center(child: CircularProgressIndicator()));

  Column _buildBookingButton(
      double price, double exchangePrice, int exchangeIndex) {
    final locale = kCurrencies[exchangeIndex]['locale'];
    final symbol = kCurrencies[exchangeIndex]['symbol'];
    final formatter = NumberFormat.currency(locale: locale, symbol: symbol);
    final priceString = formatter.format(exchangePrice);
    final exchangePriceTextStyle =
        style8.copyWith(color: Colors.black, fontSize: 14);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Hidable(
          preferredWidgetSize: const Size.fromHeight(74),
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                color: Colors.grey.withOpacity(.5),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('\$$price', style: style8),
                          Text('/Voice', style: style9),
                        ],
                      ),
                      if (exchangeIndex != 0 && priceString.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('(', style: exchangePriceTextStyle),
                            Text(priceString, style: exchangePriceTextStyle),
                            Text(')', style: exchangePriceTextStyle),
                          ],
                        )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: isBooked
                        ? null
                        : () async {
                            await placeDetailViewModel.addPlaceToCart(
                                place, context);
                            isBooked = true;
                            setState(() {});
                          },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: isBooked ? Colors.grey : AppColors.primaryColor,
                      ),
                      width: 173,
                      height: 52,
                      child: Text(context.tr('book_place'),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isBooked ? Colors.black : Colors.white,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  SliverList _buildPlaceInfos(
    String name,
    double entryTicket,
    String description,
    String openTime,
    String closeTime,
    double rate,
    List<FeedBacks> listFeedbacks,
    List<Marker> markers,
    List<Map<String, dynamic>> beacons,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: style1),
                    const Spacer(),
                  ],
                ),
                space1,
                Text(context.tr('ho_chi_minh_city'), style: style2),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        entryTicket > 0
                            ? '\$$entryTicket'
                            : context.tr('free_ticket'),
                        style: style1),
                    Text(entryTicket > 0 ? '/${context.tr('ticket')}' : '',
                        style: style2),
                  ],
                ),
                space1,
                ReadMoreText(description,
                    trimLines: 5,
                    style: style3,
                    trimCollapsedText: context.tr('read_all')),
                space2,
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: AppColors.gray7,
                      ),
                      width: 38,
                      height: 38,
                      child: const Icon(Icons.location_on_rounded,
                          color: AppColors.primaryColor),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Viet Nam', style: style4),
                          Text(
                            place.address ?? 'No address',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: style5,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                space3,
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: AppColors.gray7,
                      ),
                      width: 38,
                      height: 38,
                      child: const Icon(Icons.access_time_filled,
                          color: AppColors.primaryColor),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('open'), style: style4),
                        Text(
                            DateFormat.jm()
                                .format(DateFormat("hh:mm:ss").parse(openTime)),
                            style: style5)
                      ],
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('close'), style: style4),
                        Text(
                            DateFormat.jm().format(
                                DateFormat("hh:mm:ss").parse(closeTime)),
                            style: style5)
                      ],
                    )
                  ],
                ),
                beacons.isEmpty
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child:
                                  Text(context.tr('beacons'), style: style6)),
                          Column(
                            children: List.generate(
                              beacons.length,
                              (index) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(beacons[index]['url']),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    beacons[index]['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(context.tr('location'), style: style6)),
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    markers: Set.of(markers),
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(place.latitude!, place.longitude!),
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                listFeedbacks.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 20, bottom: 5),
                              child:
                                  Text(context.tr('reviews'), style: style6)),
                          Row(
                            children: [
                              Text('$rate'),
                              const Icon(Icons.star_rounded,
                                  size: 16, color: Color(0xFFFFB23F)),
                              Text(
                                  '  (${listFeedbacks.length} ${context.tr('reviews')})',
                                  style: style2),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(
      BuildContext context,
      List<PlaceImages> listPlaceImages,
      bool isFavorite,
      Function() onToggleFavorite,
      Function(int) onCurrencyChange) {
    return SliverAppBar(
      pinned: false,
      backgroundColor: Colors.white38,
      leading: const BackButton(),
      actions: [
        Consumer<PlaceDetailViewModel>(
          builder: (context, vm, _) {
            return Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: IconButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const CartView())),
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
                vm.quantity == 0
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor),
                        child: Text(
                          '${vm.quantity}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      )
              ],
            );
          },
        ),
        IconButton(
          onPressed: onToggleFavorite,
          icon: isFavorite
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : const Icon(Icons.favorite_outline_outlined),
        ),
        GestureDetector(
          onTap: () {
            showDialog<int>(
              context: context,
              builder: (context) {
                return ChangeCurrencyPopup(
                  selectedIndex: _exchangeIndex,
                );
              },
            ).then((index) {
              if (index != null) {
                onCurrencyChange(index);
              }
            });
          },
          child: Center(
            child: Text(
              kCurrencies[_exchangeIndex]['key'] as String,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
      flexibleSpace: FlexibleSpaceBar(
          background: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          PageView(
            controller: controller,
            onPageChanged: (value) {
              pageValue = value;
              setState(() {});
            },
            children: List.generate(
              listPlaceImages.length,
              (index) => ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(.5), BlendMode.darken),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(listPlaceImages[index].url!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white54),
            child: Text('${pageValue + 1}/${listPlaceImages.length}',
                style: const TextStyle(fontSize: 16)),
          )
        ],
      )),
      expandedHeight: MediaQuery.of(context).size.height * .4,
    );
  }
}
