import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayHelper {
  final Razorpay _razorpay;
  late String _orderId;

  RazorpayHelper()
      : _razorpay = Razorpay() {
    // Initialize the Razorpay instance
  }

  void initialize({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  Future<void> generateOrderId({
    required double amount,
    required Function(String) onOrderIdGenerated,
    required Function(String) onError,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic cnpwX2xpdmVfNE9pSDFudGZzc0NHNWY6eFcwdERrUUtVNTk4aTlSS1l1aHpuWFpo',
        },
        body: json.encode({
          'amount': (amount * 100).toInt(), // Convert amount to the smallest unit (paise)
          'currency': 'INR',
          'payment_capture': 1,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Save the generated order ID
        _orderId = data['id'];

        print("Order ID generated: $_orderId");
        print("Response Body: ${response.body}");

        // Call the success callback
        onOrderIdGenerated(_orderId);
      } else {
        print("Failed to generate order ID. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        // Call the error callback with the error message
        onError('Failed to generate order ID. Please try again.');
      }
    } catch (error) {
      print('Error generating order ID: $error');

      // Call the error callback with the error message
      onError('Error generating order ID: $error');
    }
  }

  void startPayment({
    required double amount,
    required String contact,
    required String email,
  }) {
    var options = {
      'key': 'rzp_live_4OiH1ntfssCG5f',
      'amount': (amount * 100).toInt(),
      'name': 'Demo Payment',
      'order_id': _orderId,
      'description': 'Test Payment',
      //   'timeout': 10,
      'prefill': { 'email': email},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
    }
  }
}
