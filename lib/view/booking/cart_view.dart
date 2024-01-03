import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/view/payment/choosepayment_view.dart';
import 'package:etravel_mobile/view/place/placedetail_view.dart';
import 'package:etravel_mobile/view_model/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';

import '../widgets/custom_audio_player.dart';
import '../widgets/custom_yes_no_dialog.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  var price = 0.0;
  late Future<double> priceData;
  var cartViewModel = CartViewModel();
  late Future<List<Place>> cartPlaceData;
  var bookingPlaceItems = <Place>[];
  final ScrollController scrollController = ScrollController();
  var style8 = const TextStyle(
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );
  var style9 = const TextStyle(color: AppColors.primaryColor, fontSize: 12);

  @override
  void initState() {
    cartPlaceData = cartViewModel.getCartPlace();
    priceData = cartViewModel.getCartPrice();
    cartPlaceData.then((places) => bookingPlaceItems = places);
    priceData.then((value) => price = value);
    super.initState();
  }

  Future loadData() async {
    await cartViewModel
        .getCartPlace()
        .then((value) => bookingPlaceItems = value);
    await cartViewModel.getCartPrice().then((value) => price = value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(toBeginningOfSentenceCase(context.tr('places'))!),
        actions: [
          TextButton(
            onPressed: bookingPlaceItems.isNotEmpty
                ? () async {
                    await cartViewModel.removeAllBookingItems();
                    bookingPlaceItems = [];
                    setState(() {});
                  }
                : null,
            child: Text(
              context.tr('delete_all'),
              style: const TextStyle(
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: Stack(
          children: [
            _buildCartInfos(scrollController),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
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
                    height: 74,
                    child: Row(children: [
                      const SizedBox(width: 40),
                      FutureBuilder<double>(
                        future: priceData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('\$$price', style: style8);
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                      Text('/${context.tr('total')}', style: style9),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (bookingPlaceItems.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChoosePaymentView(
                                  places: bookingPlaceItems,
                                  isCustomTour: true,
                                  price: price,
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Your cart is empty'),
                                content: const Text(
                                    'Please book some places to process payment'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.primaryColor,
                          ),
                          width: 173,
                          height: 52,
                          child: Text(
                            context.tr('payment'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _buildCartInfos(ScrollController controller) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          FutureBuilder<List<Place>>(
            future: cartPlaceData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Column(
                        children: List.generate(
                          bookingPlaceItems.length,
                          (index) {
                            var bookingItem = bookingPlaceItems[index];
                            var place = bookingItem;
                            return _buildBookingItem(
                              place.placeImages![0].url!,
                              place.name!,
                              place.price!,
                              placeId: bookingItem.id!,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Dismissible _buildBookingItem(String image, String name, double bookingPrice,
      {int? placeId}) {
    void onConfirmDeleting() async {
      Navigator.pop(context);
      if (placeId != null) {
        await cartViewModel.deletePlaceInCart(placeId);
        await cartViewModel
            .getCartPlace()
            .then((value) => bookingPlaceItems = value);
        price = 0.0;
        for (var place in bookingPlaceItems) {
          price += place.price!;
        }
        setState(() {});
      }
    }

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final confirmed = await showDialog(
          context: context,
          builder: (context) {
            return CustomYesNoDialog(
                yesContent: context.tr('yes'),
                noContent: context.tr('no'),
                title: '${context.tr('remove')} $name',
                content: context.tr('are_you_sure_you_want_to_delete'),
                // assetImagePath: '',
                //assetImagePath: 'assets/images/booking/delete.png',
                icon: const Icon(
                  Icons.remove_shopping_cart,
                  color: AppColors.primaryColor,
                  size: 70,
                ),
                onYes: onConfirmDeleting,
                onNo: () {
                  Navigator.of(context).pop(false);
                });
          },
        );
        return confirmed;
      },
      background: const ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaceDetailsView(placeId: placeId!),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                width: 124,
                height: 124,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.shopping_bag_outlined),
                      const SizedBox(width: 10),
                      Text('\$$bookingPrice USD'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
