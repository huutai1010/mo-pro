import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/feedback.dart';
import 'package:flutter/material.dart';

import '../../res/colors/app_color.dart';
import '../../utils/utils.dart';

class FeedbackItem extends StatefulWidget {
  FeedbackItem({
    super.key,
    required this.feedback,
    required this.isLastItem,
    required this.rating,
    this.createTime,
  });

  final FeedBacks feedback;
  final bool isLastItem;
  final double rating;
  String? createTime;

  @override
  State<FeedbackItem> createState() => _FeedbackItemState();
}

class _FeedbackItemState extends State<FeedbackItem> {
  bool _isTranslating = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 15,
        bottom: widget.isLastItem ? 30 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.searchBorderColor.withOpacity(.5),
          width: .5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.feedback.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 35,
                    height: 35,
                  ),
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              widget.feedback.nationalImage ??
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
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${widget.feedback.firstName!} ${widget.feedback.lastName!}',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    Row(
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Text(widget.createTime != null
                                  ? DateFormat('MMMM d, yyyy').format(
                                      DateTime.parse(widget.createTime!))
                                  : ' .23 July 2023'),
                              const SizedBox(width: 10),
                              Row(children: [
                                Text('${widget.rating}'),
                                const Icon(Icons.star_rounded,
                                    size: 16, color: Color(0xFFFFB23F))
                              ]),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FutureBuilder(
                future:
                    Utils.translate(_isTranslating, widget.feedback.content!),
                builder: (ctx, snapshot) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      (snapshot.hasData
                              ? snapshot.data
                              : (widget.feedback.content!)) ??
                          'Lorem ipsum dolor sit amet, consectetur \nadipiscing elit. Etiam tellus in pretium \ndignissim',
                      style: TextStyle(
                          color: Colors.black.withOpacity(.8), fontSize: 13),
                    ),
                  );
                }),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isTranslating = !_isTranslating;
                });
              },
              child: Text(
                context.tr(_isTranslating ? 'view_source' : 'translate'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
