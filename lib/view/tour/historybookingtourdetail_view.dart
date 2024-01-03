import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HistoryBookingTourDetailView extends StatelessWidget {
  const HistoryBookingTourDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          context.tr('celebrated_images'),
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            4,
            (index) {
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
