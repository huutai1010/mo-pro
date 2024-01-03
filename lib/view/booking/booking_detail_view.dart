import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/booking.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/models/transaction_overview.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/view/exception/exception_view.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view/payment/payment_processing_view.dart';
import 'package:etravel_mobile/view/widgets/custom_audio_player.dart';
import 'package:etravel_mobile/view_model/bookingdetail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_yes_no_dialog.dart';

class BookingDetailView extends StatefulWidget {
  final int id;
  final String statusName;
  const BookingDetailView({
    required this.id,
    required this.statusName,
    super.key,
  });

  @override
  State<BookingDetailView> createState() => _BookingDetailViewState();
}

class _BookingDetailViewState extends State<BookingDetailView> {
  late Future<Booking?> bookingData;
  final bookingDetailViewModel = BookingDetailViewModel();
  late Booking booking;
  TransactionOverview? transactionOverview;
  final textStyle =
      const TextStyle(color: Color(0xFF808080), fontWeight: FontWeight.w500);

  void _onContinuePayment() {
    final paymentUrl = booking.transactions?.first.paymentUrl;
    final placesFromBooking = booking.bookingPlaces?.map((bPlace) {
          final bPlaceJson = bPlace.toJson();
          return Place.fromJson(bPlaceJson);
        }) ??
        [];
    if (paymentUrl != null && placesFromBooking.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return PaymentProcessingView(
          paymentUrl: paymentUrl,
          ordinalPlaces: placesFromBooking.toList(),
        );
      }));
    }
  }

  Color getTextColor(int status) {
    switch (status) {
      case 1:
        return const Color(0xFF00AB56);

      case 0:
        return Colors.orange;
      case 5:
        return AppColors.primaryColor;
      default:
        return Colors.white;
    }
  }

  void onCancelBooking() async {
    showDialog<bool>(
      context: context,
      builder: (c) {
        return CustomYesNoDialog(
            yesContent: c.tr('yes'),
            noContent: c.tr('no'),
            title: c.tr('cancel_booking'),
            content: c.tr('are_you_sure_you_want_to_cancel_this_booking'),
            icon: const Icon(
              Icons.event_busy,
              size: 70,
              color: AppColors.primaryColor,
            ),
            onYes: () {
              Navigator.of(c).pop(true);
            },
            onNo: () {
              Navigator.of(c).pop(false);
            });
      },
    ).then((accepted) {
      if (accepted ?? false) {
        return bookingDetailViewModel
            .cancelBooking(widget.id)
            .then((value) => true);
      }
      return Future.value(false);
    }).then((value) {
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('booking_cancelled')),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  void initState() {
    bookingData = bookingDetailViewModel.getBookingDetail(widget.id);
    bookingData.then((value) {
      if (value != null) {
        booking = value;
        if (booking.transactions != null) {
          if (booking.transactions!.isNotEmpty) {
            transactionOverview = booking.transactions![0];
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookingDetailViewModel>(
      create: (context) => bookingDetailViewModel,
      child: Consumer<BookingDetailViewModel>(builder: (context, vm, _) {
        return vm.isFailed
            ? ExceptionView(onRefresh: () {
                vm.setFailed(false);
                setState(() {});
              })
            : Scaffold(
                backgroundColor: const Color(0xFFF5F5F5),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  leading: const BackButton(),
                  title: Text(
                    context.tr('booking_details'),
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
                body: FutureBuilder(
                  future: bookingData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  Text(
                                    context.tr('general_info'),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Text(context.tr('booking_id'),
                                                  style: textStyle),
                                              const Spacer(),
                                              Text('${booking.id}'),
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Text(context.tr('booking_date'),
                                                  style: textStyle),
                                              const Spacer(),
                                              Text(DateFormat(
                                                      'dd-MM-yyyy HH:mm')
                                                  .format(booking.createTime!)),
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                context.tr('status_name'),
                                              ),
                                              const Spacer(),
                                              Text(
                                                context.tr(
                                                    (booking.statusName ?? '')
                                                        .toLowerCase()),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: getTextColor(
                                                      booking.status!),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    context.tr('places_booking'),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white),
                                    child: Column(
                                      children: List.generate(
                                        booking.bookingPlaces!.length,
                                        (index) => Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        booking
                                                            .bookingPlaces![
                                                                index]
                                                            .placeImage!,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      booking
                                                          .bookingPlaces![index]
                                                          .placeName!,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                        '\$${booking.bookingPlaces![index].price!}'),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            index !=
                                                    booking.bookingPlaces!
                                                            .length -
                                                        1
                                                ? const Divider()
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    context.tr('payment_info'),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                    context
                                                        .tr('payment_method'),
                                                    style: textStyle),
                                                const Spacer(),
                                                Text(
                                                  transactionOverview
                                                          ?.paymentMethod ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Text(context.tr('payment_time'),
                                                    style: textStyle),
                                                const Spacer(),
                                                Text(
                                                  transactionOverview
                                                              ?.createTime ==
                                                          null
                                                      ? "No time"
                                                      : DateFormat(
                                                              'dd-MM-yyyy HH:mm')
                                                          .format(
                                                          transactionOverview
                                                                  ?.createTime! ??
                                                              DateTime.now(),
                                                        ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Text(context.tr('amount'),
                                                    style: textStyle),
                                                const Spacer(),
                                                Text(transactionOverview
                                                            ?.amount ==
                                                        null
                                                    ? "No amount"
                                                    : "\$${transactionOverview?.amount}")
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Text(context.tr('status_name'),
                                                    style: textStyle),
                                                const Spacer(),
                                                Text(transactionOverview
                                                            ?.statusType ==
                                                        null
                                                    ? "No status"
                                                    : "${transactionOverview?.statusType}")
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(height: 15),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          context.tr('total'),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${booking.total} USD',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  widget.statusName == 'ToPay'
                                      ? Column(
                                          children: [
                                            GestureDetector(
                                              onTap: _onContinuePayment,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 15),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors.primaryColor,
                                                ),
                                                alignment: Alignment.center,
                                                width: double.infinity,
                                                height: 45,
                                                child: Text(
                                                  context
                                                      .tr('continue_payment'),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: onCancelBooking,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 15),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors
                                                          .primaryColor,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                alignment: Alignment.center,
                                                width: double.infinity,
                                                height: 45,
                                                child: Text(
                                                  context.tr('cancel_booking'),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return const LoadingView();
                  },
                ),
              );
      }),
    );
  }
}
