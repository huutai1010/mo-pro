// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/helper/convert_duration.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view/payment/payment_processing_view.dart';
import 'package:etravel_mobile/view_model/placenotgone_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../res/colors/app_color.dart';

class ChoosePaymentView extends StatefulWidget {
  int? tourId;
  List<Place> places;
  bool isCustomTour;
  double price;
  double totalTime;
  double totalDistance;
  ChoosePaymentView({
    Key? key,
    this.tourId,
    required this.places,
    this.isCustomTour = false,
    this.totalTime = 0.0,
    this.totalDistance = 0.0,
    required this.price,
  }) : super(key: key);

  @override
  State<ChoosePaymentView> createState() => _ChoosePaymentViewState();
}

class _ChoosePaymentViewState extends State<ChoosePaymentView> {
  int _paymentOption = PaymentOption.Paypal;
  final _placeNotGoneViewModel = PlaceNotGoneViewModel();
  bool _isLoading = false;
  var firstName = '';
  var lastName = '';
  var phone = '';
  bool paymentProcessLoading = false;

  Future setupUserInfo() async {
    await LocalStorageService.getInstance.getAccount().then((value) {
      firstName = value?.firstName ?? '';
      lastName = value?.lastName ?? '';
      phone = value?.phone ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return paymentProcessLoading
        ? const LoadingView()
        : Scaffold(
            appBar: AppBar(
              title: Text(context.tr('confirm_and_payment')),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: setupUserInfo(),
                          builder: (context, snapshot) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        context
                                            .tr('customer_information')
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              context.tr('customer_name'),
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '$firstName $lastName',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              context.tr('phone_number'),
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const Spacer(),
                                            Text(
                                              phone,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Container(
                          width: double.infinity,
                          height: 5,
                          color: Colors.grey.withOpacity(.1),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Row(
                            children: [
                              Text(
                                context.tr('places_booking').toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(
                            widget.places.length,
                            (index) => Container(
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 25,
                                      bottom: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: widget.isCustomTour
                                            ? NetworkImage(widget.places[index]
                                                .placeImages![0].url!)
                                            : NetworkImage(
                                                widget.places[index].image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            widget.places[index].name!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          '${widget.places[index].price}\$',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 5,
                          color: Colors.grey.withOpacity(.1),
                        ),
                        const SizedBox(height: 10),
                        FractionallySizedBox(
                          widthFactor: .85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.tr('payment').toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        _getOptionPayment(),
                        const SizedBox(height: 10),
                        _getOptionPayment(
                            isCardPaymentOption: true, isSecond: true),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      offset: const Offset(-2, -2),
                      blurRadius: 2,
                      spreadRadius: 2,
                      color: Colors.grey.withOpacity(.3),
                    )
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  context.tr('total'),
                                  style: TextStyle(
                                      color: Colors.grey.withOpacity(.5)),
                                ),
                                const SizedBox(width: 5),
                                Text('\$${widget.price}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22)),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () async {
                                  var visitTimes = 0;
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (_paymentOption == PaymentOption.Paypal) {
                                    var ordinalPlaces = <Place>[];
                                    if (widget.isCustomTour == false) {
                                      await _placeNotGoneViewModel
                                          .managePlacesOrdinalV2(widget.places)
                                          .then((value) {
                                        ordinalPlaces = value;
                                        for (var place in ordinalPlaces) {
                                          print(place.name);
                                        }
                                        widget.totalTime =
                                            _placeNotGoneViewModel.totalTime;
                                        widget.totalDistance =
                                            _placeNotGoneViewModel
                                                .totalDistance;
                                      });
                                    }
                                    if (!widget.isCustomTour) {
                                      var durations = widget.places
                                          .map(
                                              (e) => parseDuration(e.duration!))
                                          .toList();
                                      for (var duration in durations) {
                                        visitTimes += duration.inSeconds;
                                      }
                                    }

                                    final mockDataExistingTour =
                                        widget.isCustomTour
                                            ? {
                                                "isExistingTour": false,
                                                "tourId": 0,
                                                "paymentMethod": _paymentOption,
                                                "totalTime": 0.0,
                                                "totalDistance": 0.0,
                                                "bookingPlaces": List.generate(
                                                  widget.places.length,
                                                  (index) => {
                                                    "placeId":
                                                        widget.places[index].id,
                                                    "ordinal": (index + 1),
                                                  },
                                                )
                                              }
                                            : {
                                                "isExistingTour": true,
                                                "tourId": widget.tourId,
                                                "paymentMethod": _paymentOption,
                                                "totalTime": (widget.totalTime +
                                                        visitTimes) /
                                                    3600,
                                                "totalDistance":
                                                    widget.totalDistance / 1000,
                                                "bookingPlaces": List.generate(
                                                  ordinalPlaces.length,
                                                  (index) => {
                                                    "placeId":
                                                        ordinalPlaces[index].id,
                                                    "ordinal": (index + 1),
                                                  },
                                                )
                                              };
                                    paymentProcessLoading = true;
                                    setState(() {});
                                    await BookingRepository()
                                        .postBooking(mockDataExistingTour)
                                        .then((response) async {
                                      paymentProcessLoading = false;
                                      await LocalStorageService.getInstance
                                          .clearCart()
                                          .then((value) {
                                        setState(() {});
                                        final approvalLink = response['href'];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                PaymentProcessingView(
                                              paymentUrl: approvalLink,
                                              ordinalPlaces: ordinalPlaces,
                                            ),
                                          ),
                                        ).then((value) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      });
                                    });
                                  }
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: !_isLoading
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                            ),
                            height: 50,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.wallet, color: Colors.white),
                                  const SizedBox(width: 5),
                                  Text(
                                    context.tr('pay_now').toTitleCase!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _getOptionPayment(
      {bool isCardPaymentOption = false, bool isSecond = false}) {
    return GestureDetector(
      onTap: () {
        if (isCardPaymentOption) {
          _paymentOption = PaymentOption.Card;
        } else {
          _paymentOption = PaymentOption.Paypal;
        }
        setState(() {});
      },
      child: FractionallySizedBox(
        widthFactor: .7,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          height: 40,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            isCardPaymentOption
                ? Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/MasterCard_early_1990s_logo.svg/200px-MasterCard_early_1990s_logo.svg.png'),
                          ),
                        ),
                        width: 40,
                        height: 30,
                      )
                    ],
                  )
                : Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://imgsrv2.voi.id/AB0I4tQ4k2K9kZR9Uj5Ya-OE7Gny2KI3ZuHo3Pd_lFk/auto/1200/675/sm/1/bG9jYWw6Ly8vcHVibGlzaGVycy8xODY1NTYvMjAyMjA3MDUxMTQyLW1haW4uY3JvcHBlZF8xNjU2OTk2MTUxLmpwZWc.jpg'),
                      ),
                    ),
                    width: 40,
                    height: 30,
                  ),
            //const Spacer(),
            Expanded(
              child: Center(
                child: Container(
                  child: Text(
                    isCardPaymentOption
                        ? context.tr('credit_card')
                        : context.tr('online_payment'),
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                ),
              ),
            ),
            //const Spacer(),
            Radio<int>(
              toggleable: true,
              value: isSecond ? PaymentOption.Card : PaymentOption.Paypal,
              groupValue: _paymentOption,
              activeColor: Colors.black,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _paymentOption = value;
                  });
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}

class PaymentOption {
  static const Paypal = 3;
  static const Card = 1;
}
