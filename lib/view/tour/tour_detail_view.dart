import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/const/const.dart';
import 'package:etravel_mobile/models/tour.dart';
import 'package:etravel_mobile/view/exception/exception_view.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view_model/tour_detail_viewmodel.dart';
import 'package:hidable/hidable.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../res/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../utils/utils.dart';
import '../success/change_currency_popup.dart';

class TourDetailView extends StatefulWidget {
  final int tourId;
  final Map<String, double> exchanges;

  const TourDetailView({
    super.key,
    required this.tourId,
    required this.exchanges,
  });
  @override
  State<StatefulWidget> createState() => _TourDetailViewState();
}

class _TourDetailViewState extends State<TourDetailView> {
  int _exchangeIndex = 0;
  bool isBooked = false;
  late Future<bool> isBookingItemData;
  final ScrollController scrollController = ScrollController();
  late Tour? tour;
  late Future getTourDetail;
  final TourDetailViewModel tourDetailViewModel = TourDetailViewModel();

  @override
  void initState() {
    getTourDetail = getTourDetails();
    super.initState();
  }

  _onCurrencyChange() {
    showDialog<int>(
      context: context,
      builder: (context) {
        return ChangeCurrencyPopup(
          selectedIndex: _exchangeIndex,
        );
      },
    ).then((index) {
      if (index != null) {
        setState(() {
          _exchangeIndex = index;
        });
      }
    });
  }

  Future getTourDetails() async {
    await tourDetailViewModel
        .getTourdetail(widget.tourId)
        .then((value) => tour = value);
  }

  @override
  Widget build(BuildContext context) {
    final exchangeKey = kCurrencies[_exchangeIndex]['key'] as String;
    final exchangePrice = widget.exchanges[exchangeKey] as double;
    final locale = kCurrencies[_exchangeIndex]['locale'];
    final symbol = kCurrencies[_exchangeIndex]['symbol'];
    final formatter = NumberFormat.currency(locale: locale, symbol: symbol);
    final priceString = formatter.format(exchangePrice);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<TourDetailViewModel>(
      create: (context) => tourDetailViewModel,
      child: Consumer<TourDetailViewModel>(builder: (context, vm, _) {
        return vm.isFailed
            ? ExceptionView(onRefresh: () {
                vm.setFailed(false);
                setState(() {});
              })
            : FutureBuilder(
                future: getTourDetail,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingView();
                  } else {
                    return Scaffold(
                      body: Stack(
                        children: [
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                    alignment: AlignmentDirectional.bottomStart,
                                    children: [
                                      TopImageSection(
                                        screenWidth: screenWidth,
                                        screenHeight: screenHeight,
                                        image: tour?.image ?? '',
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                            screenWidth * 20 / 375),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tour?.name ?? 'No name found',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${tour?.rate}',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Icon(Icons.star_rounded,
                                                    size: 16,
                                                    color: Color(0xFFFFB23F)),
                                                Text(
                                                  '  .${tour?.feedBacks?.length} ${context.tr('reviews')}',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                InfoSection(
                                  tour: tour,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                ),
                              ],
                            ),
                          ),
                          //),
                          SizedBox(
                            width: screenWidth,
                            height: screenHeight,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: screenWidth * 20 / 375,
                                    right: screenWidth * 20 / 375,
                                    top: screenHeight * 40 / 812,
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          width: screenWidth * 36 / 375,
                                          height: screenWidth * 36 / 375,
                                          child: const Icon(Icons.arrow_back),
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: _onCurrencyChange,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          width: 36,
                                          height: 36,
                                          child: Center(
                                            child: Text(
                                              exchangeKey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Hidable(
                                  preferredWidgetSize:
                                      const Size.fromHeight(74),
                                  controller: scrollController,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, -2),
                                            color: Colors.grey.withOpacity(.5),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                          ),
                                        ]),
                                    height: screenHeight * 100 / 812,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 30 / 375),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '\$${tour?.price}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Text(
                                                  '/${context.tr('tour')}',
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (_exchangeIndex != 0)
                                              Row(
                                                children: [
                                                  const Text(
                                                    '(',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  Text(
                                                    priceString,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const Text(
                                                    ')',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () async {
                                            await tourDetailViewModel.bookTour(
                                              context,
                                              tour?.places ?? [],
                                              widget.tourId,
                                              tour?.price ?? 0,
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: AppColors.primaryColor,
                                            ),
                                            width: 150,
                                            height: 45,
                                            alignment: Alignment.center,
                                            child: Text(
                                              context.tr('book_tour'),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
      }),
    );
  }
}

class InfoSection extends StatefulWidget {
  const InfoSection({
    super.key,
    required this.tour,
    required this.screenWidth,
    required this.screenHeight,
  });

  final Tour? tour;
  final double screenWidth;
  final double screenHeight;

  @override
  State<StatefulWidget> createState() => _InfoSectionState();
}

class _InfoSectionState extends State<InfoSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.screenWidth * 16 / 375,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: widget.screenHeight * 15 / 812),
          Row(
            children: [
              Text(
                context.tr('about'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  // color: AppColors.placeDetailTitleColor,
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: widget.screenHeight * 15 / 812),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ReadMoreText(widget.tour?.description ?? '',
                trimLines: 5,
                style: const TextStyle(
                  color: AppColors.placeDetailTitleColor,
                ),
                trimCollapsedText: context.tr('read_all')),
          ),
          SizedBox(height: widget.screenHeight * 30 / 812),
          const Divider(),
          Row(
            children: [
              Text(
                context.tr('where_will_you_go'),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
            ],
          ),
          Column(
            children: List.generate(widget.tour?.places?.length ?? 0, (index) {
              return Container(
                margin: EdgeInsets.only(
                    top: index == 0 ? widget.screenHeight * 20 / 812 : 0,
                    bottom: widget.screenHeight * 20 / 812),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              widget.tour?.places?[index].image ?? ''),
                        ),
                      ),
                      width: 86,
                      height: 86,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 86,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                widget.tour?.places?[index].name ??
                                    'Name not found',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${context.tr('open')}'
                                  ': ${widget.tour?.places?[index].openTime?.substring(0, 5) ?? 'Time not found'}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                Text(
                                  '${context.tr('close')}'
                                  ': ${widget.tour?.places?[index].endTime?.substring(0, 5)}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const Divider(),
          SizedBox(height: widget.screenHeight * 15 / 812),
          Row(
            children: [
              Text(
                context.tr('photos'),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: widget.screenHeight * 15 / 812),
          Column(
            children: [
              StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: List.generate(
                  widget.tour?.places?.length ?? 0,
                  (index) => Container(
                    width: 168,
                    height: index == 0 ? 291 : 144,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            widget.tour?.placeImages?[index].url ?? ''),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: widget.screenHeight * 30 / 812),
              const Divider(),
              widget.tour?.feedBacks != null &&
                      // ignore: prefer_is_empty
                      widget.tour?.feedBacks!.length != 0
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              context.tr('reviews'),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                          ],
                        ),
                        Row(
                          children: [
                            Text('${widget.tour?.rate ?? 'No rating found'}'),
                            const Icon(Icons.star_rounded,
                                size: 16, color: Color(0xFFFFB23F)),
                            Text(
                                ' (${widget.tour?.feedBacks?.length ?? 'No feedbacks found'} ${context.tr('reviews')})'),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(height: widget.screenHeight * 15 / 812),
                      ],
                    )
                  : Container(),
            ],
          ),
          Center(
            child: Column(
              children: List.generate(
                widget.tour?.feedBacks?.length ?? 0,
                (index) => FeedbackItem(
                  firstName: widget.tour?.feedBacks?[index].firstName,
                  lastName: widget.tour?.feedBacks?[index].lastName,
                  image: widget.tour?.feedBacks?[index].image,
                  nationalImage: widget.tour?.feedBacks?[index].nationalImage,
                  content: widget.tour?.feedBacks?[index].content,
                  createTime: widget.tour?.feedBacks?[index].createTime,
                  screenWidth: widget.screenWidth,
                  screenHeight: widget.screenHeight,
                  rating: widget.tour?.rate,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackItem extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? nationalImage;
  final String? content;
  final String? createTime;
  final double? rating;
  const FeedbackItem({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    this.firstName,
    this.lastName,
    this.image,
    this.nationalImage,
    this.content,
    this.createTime,
    this.rating,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<FeedbackItem> createState() => _FeedbackItemState();
}

class _FeedbackItemState extends State<FeedbackItem> {
  bool _isTranslating = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.screenHeight * 20 / 812),
      decoration: BoxDecoration(
        border: Border.all(
          width: .5,
          color: AppColors.searchBorderColor.withOpacity(.5),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      width: widget.screenWidth * 327 / 375,
      //height: widget.screenHeight * 199 / 812,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.screenHeight * 10 / 812,
            left: widget.screenWidth * 10 / 375,
            bottom: widget.screenHeight * 10 / 812),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(widget.image ??
                                  'https://images.unsplash.com/photo-1527980965255-d3b416303d12?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YXZhdGFyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60'))),
                      width: widget.screenWidth * 35 / 375,
                      height: widget.screenWidth * 35 / 375,
                    ),
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                widget.nationalImage ??
                                    'https://images.unsplash.com/photo-1527980965255-d3b416303d12?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YXZhdGFyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60',
                              ),
                              fit: BoxFit.cover),
                        ),
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: widget.screenWidth * 10 / 375),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          (widget.firstName ?? 'Jack'),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(widget.lastName ?? ' Daniel',
                            style: const TextStyle(fontWeight: FontWeight.w500))
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(widget.createTime != null
                            ? DateFormat('MMMM d, yyyy')
                                .format(DateTime.parse(widget.createTime!))
                            : ' .23 July 2023'),
                        const SizedBox(width: 10),
                        Row(children: [
                          Text('${widget.rating}'),
                          const Icon(Icons.star_rounded,
                              size: 16, color: Color(0xFFFFB23F))
                        ]),
                      ],
                    ),
                  ],
                )
              ],
            ),
            FutureBuilder(
              future: Utils.translate(_isTranslating, widget.content!),
              builder: (ctx, snapshot) => Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  (snapshot.hasData ? snapshot.data : widget.content!) ??
                      'Lorem ipsum dolor sit amet, consectetur \nadipiscing elit. Etiam tellus in pretium \ndignissim ',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withOpacity(.8),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isTranslating = !_isTranslating;
                });
              },
              child: Text(
                _isTranslating
                    ? context.tr('view_source')
                    : context.tr('translate'),
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopImageSection extends StatelessWidget {
  const TopImageSection({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.image,
  });

  final double screenWidth;
  final double screenHeight;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(image),
        ),
      ),
      width: screenWidth,
      height: screenHeight * 324 / 812,
    );
  }
}
