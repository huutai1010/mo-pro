import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view/success/payment_success.dart';
import 'package:etravel_mobile/view_model/placenotgone_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentProcessingView extends StatefulWidget {
  final String paymentUrl;
  final List<Place> ordinalPlaces;
  const PaymentProcessingView({
    required this.paymentUrl,
    required this.ordinalPlaces,
    super.key,
  });

  @override
  State<PaymentProcessingView> createState() => _PaymentProcessingViewState();
}

class _PaymentProcessingViewState extends State<PaymentProcessingView> {
  bool isConfirming = false;

  _onNavigate(url) async {
    if (url.contains('/transactions/cancel')) {
      Navigator.of(context).pop();
    } else if (url.contains('/transactions/confirm')) {
      setState(() {
        isConfirming = true;
      });
      await BookingRepository().confirmBooking(url).then((response) async {
        print(response);
        if (response['journeyId'] != null) {
          final placeNotGoneViewModel = PlaceNotGoneViewModel();
          await placeNotGoneViewModel
              .createRoutes(widget.ordinalPlaces)
              .then((value) async {
            await placeNotGoneViewModel.saveUserJourneyRoutes(
                value, response['journeyId']);
          });
        }
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PaymentSuccessfulView(),
          ),
        );
      }).catchError((err) {
        loggerInfo.i('Confirming failed');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onPageStarted: _onNavigate,
                    onNavigationRequest: (_) {
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(Uri.parse(widget.paymentUrl)),
            ),
            isConfirming ? const LoadingView() : const Stack(),
          ],
        ),
      ),
    );
  }
}
