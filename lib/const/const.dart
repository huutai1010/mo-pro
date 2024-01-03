import 'package:flutter/material.dart';

import '../res/colors/app_color.dart';

const titleTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
);

List<Widget> generateRowItem(
  Widget leftContent,
  Widget rightContent, {
  double spacing = 0,
}) {
  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: leftContent,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(flex: 1, child: rightContent),
      ],
    ),
    SizedBox(
      height: spacing,
    )
  ];
}

const kDateFormat = 'dd-MM-yyyy';
const kDateTimeFormat = 'HH:mm:ss dd/MM/yyyy';

const kGender = [
  'Male',
  'Female',
];

const kSeekTimeInMilliseconds = 10000.0; // 10 seconds

const kDefaultImage =
    'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXZhdGFyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60';

const kCurrencies = [
  {
    'key': 'USD',
    'name': 'United States Dollar',
    'image': 'usa',
    'format': '\${0}',
    'locale': 'en_US',
  },
  {
    'key': 'VND',
    'name': 'Vietnamese Dong',
    'image': 'vietnam',
    'symbol': 'VND',
    'locale': 'vi_VN',
  },
  {
    'key': 'JPY',
    'name': 'Japanese Yen',
    'image': 'japan',
    'symbol': '¥',
    'locale': 'ja',
  },
  {
    'key': 'CNH',
    'name': 'Chinese Yuan',
    'image': 'chinese',
    'symbol': '￥',
    'locale': 'zh',
  },
  {
    'key': 'SGD',
    'name': 'Singapore Dollar',
    'image': 'singapore',
    'symbol': 'SG\$',
    'locale': 'en_SG',
  },
  {
    'key': 'RUB',
    'name': 'Russian Ruble',
    'image': 'russia',
    'symbol': '₽',
    'locale': 'ru_RU',
  },
  {
    'key': 'INR',
    'name': 'Indian Rupee',
    'image': 'india',
    'symbol': '₹',
    'locale': 'en_IN',
  },
  {
    'key': 'CAD',
    'name': 'Canadian Dollar',
    'image': 'canada',
    'symbol': 'CA\$',
    'locale': 'en_CA',
  },
  {
    'key': 'KRW',
    'name': 'South Korean Won',
    'image': 'south_korea',
    'symbol': '₩',
    'locale': 'ko_KR',
  },
];

var kElevatedButtonDialogYesStyle = ElevatedButton.styleFrom(
  elevation: 0,
  side: const BorderSide(
    width: 1.0,
    color: AppColors.primaryColor,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),
);

var kElevatedButtonDialogNoStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  side: const BorderSide(
    width: 1.0,
    color: AppColors.primaryColor,
  ),
  elevation: 0,
  backgroundColor: Colors.white,
  foregroundColor: AppColors.primaryColor,
);
