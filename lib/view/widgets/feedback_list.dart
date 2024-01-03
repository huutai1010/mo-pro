import 'package:etravel_mobile/models/feedback.dart';
import 'package:etravel_mobile/view/widgets/feedback_item.dart';
import 'package:flutter/material.dart';

class FeedbackList extends StatelessWidget {
  final List<FeedBacks> feedbacks;
  const FeedbackList({
    required this.feedbacks,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: feedbacks.length,
        (context, index) => FeedbackItem(
          feedback: feedbacks[index],
          isLastItem: index == feedbacks.length - 1,
          rating: feedbacks[index].rate ?? 0.0,
          createTime: feedbacks[index].createTime,
        ),
      ),
    );
  }
}
