import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/const/const.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

import 'item_detail_dialog.dart';

class CelebrateItem extends StatefulWidget {
  final Place place;
  final DateTime time;
  const CelebrateItem({required this.place, required this.time, super.key});

  @override
  State<CelebrateItem> createState() => _CelebrateItemState();
}

class _CelebrateItemState extends State<CelebrateItem> {
  var _index = 0;
  final controller = PageController();

  void _onImageTap(String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) {
        return ItemDetailDialog(
          onShowSaveDialog: () => _onShowSaveDialog(ctx, imageUrl),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  imageUrl,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onShowSaveDialog(BuildContext ctx, String imageUrl) {
    return showDialog(
      context: ctx,
      builder: (c) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              child: const Text('Save'),
              onPressed: () => _onSaveImage(ctx, imageUrl),
            )
          ],
        );
      },
    ).then((isSuccess) {
      if (isSuccess) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text(ctx.tr('successs')),
          ),
        );
      }
    });
  }

  void _onSaveImage(BuildContext ctx, String imageUrl) async {
    final imageData = await http.get(Uri.parse(imageUrl));
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(imageData.bodyBytes),
    );
    if (result['isSuccess'] as bool && context.mounted) {
      Navigator.of(ctx).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeImages = widget.place.placeImages;
    final imagesLength = placeImages?.length ?? 0;
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.place.name ?? 'placeholder',
                style: titleTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(DateFormat(kDateFormat).format(widget.time)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Stack(children: [
              GestureDetector(
                onTap: () {
                  _onImageTap(
                    placeImages![_index].url!,
                  );
                },
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (value) {
                    setState(() {
                      _index = value;
                    });
                  },
                  itemCount: widget.place.placeImages?.length,
                  itemBuilder: (ctx, index) => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.place.placeImages?[_index].url ??
                              'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXZhdGFyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.grey,
                  ),
                  child: Text(
                    '${_index + 1}/$imagesLength',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
          if (imagesLength > 1)
            SmoothPageIndicator(
              controller: controller,
              count: imagesLength,
              effect: const ScrollingDotsEffect(
                dotColor: AppColors.gray7,
                activeDotColor: AppColors.primaryColor,
                dotWidth: 6,
                dotHeight: 6,
                spacing: 5,
              ),
            ),
        ],
      ),
    );
  }
}
