import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/view/success/feedback_success.dart';
import 'package:etravel_mobile/view_model/feedback_viewmodel.dart';
import 'package:etravel_mobile/view_model/tour_detail_viewmodel.dart';
import 'package:etravel_mobile/view_model/tourtracking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FeedbackView extends StatefulWidget {
  int journeyId;
  int? tourId;
  String? tourFeedbackName;
  String? tourFeedbackImage;
  List<Place> places;
  TourTrackingViewModel tourTrackingViewModel;
  FeedbackView({
    required this.tourTrackingViewModel,
    required this.journeyId,
    required this.places,
    this.tourId,
    this.tourFeedbackName,
    this.tourFeedbackImage,
    super.key,
  });

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class FeedbackItem {
  TextEditingController controller;
  String content;
  double rate;
  int placeId;
  FeedbackItem({
    required this.controller,
    required this.content,
    required this.rate,
    required this.placeId,
  });
}

class _FeedbackViewState extends State<FeedbackView> {
  var _feedbacks = <FeedbackItem>[];
  final _feedbackViewModel = FeedbackViewModel();
  final TextEditingController _tourEditController = TextEditingController();
  String tourFeedbackContent = '';
  double tourRate = 5.0;
  bool _isSubmitting = false;

  @override
  void initState() {
    _feedbacks = widget.places
        .map(
          (e) => FeedbackItem(
            controller: TextEditingController(),
            content: '',
            rate: 5.0,
            placeId: e.placeId!,
          ),
        )
        .toList();
    super.initState();
  }

  void _onSubmitFeedback() async {
    setState(() {
      _isSubmitting = true;
    });
    if (widget.tourId != null &&
        widget.tourId! > 0 &&
        tourFeedbackContent.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(context.tr('your_tour_feedback_is_empty')),
          content: Text(context.tr('please_give_your_tour_some_feedback')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        ),
      );
    } else {
      await _feedbackViewModel
          .createFeedback(
        journeyId: widget.journeyId,
        tourId: widget.tourId,
        tourContent: tourFeedbackContent,
        tourRate: tourRate,
        feedbackItems: _feedbacks,
        context: context,
      )
          .then(
        (value) {
          if (value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FeedbackSuccessfulView(),
              ),
            );
          }
        },
      );
    }
    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('feedback')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget.tourId != 0
                ? _buildFeedbackItem(0)
                : Column(
                    children: List.generate(
                      widget.places.length,
                      (index) => _buildFeedbackItem(index),
                    ),
                  ),
            GestureDetector(
              onTap: !_isSubmitting
                  ? () {
                      widget.tourTrackingViewModel.setNotFeedback(false);
                      _onSubmitFeedback();
                    }
                  : null,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: !_isSubmitting ? AppColors.primaryColor : Colors.grey,
                ),
                alignment: Alignment.center,
                width: double.infinity,
                height: 60,
                child: Text(
                  context.tr('done'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SizedBox _buildFeedbackItem(int index) {
    return SizedBox(
      child: Column(children: [
        SizedBox(height: index == 0 ? 25 : 0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                    widget.tourId != 0
                        ? widget.tourFeedbackImage!
                        : widget.places[index].bookingPlaceImage!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              width: 110,
              height: 110,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tourId != null && widget.tourId! > 0
                        ? widget.tourFeedbackName!
                        : widget.places[index].name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    itemSize: 30,
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      if (widget.tourId != null && widget.tourId! > 0) {
                        tourRate = rating;
                      } else {
                        _feedbacks[index].rate = rating;
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.searchBorderColor.withOpacity(.3))),
                child: TextFormField(
                  controller: widget.tourId != null && widget.tourId! > 0
                      ? _tourEditController
                      : _feedbacks[index].controller,
                  maxLines: 3,
                  decoration: InputDecoration.collapsed(
                      hintStyle:
                          const TextStyle(color: AppColors.searchBorderColor),
                      hintText: context.tr('feedback_here')),
                  onChanged: (value) {
                    widget.tourId != null && widget.tourId! > 0
                        ? tourFeedbackContent = value
                        : _feedbacks[index].content = value;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25)
      ]),
    );
  }
}
