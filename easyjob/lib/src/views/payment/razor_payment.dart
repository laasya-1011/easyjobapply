import 'dart:async';

import 'package:easyjob/src/views/job/joblist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:get/get.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:fluttertoast/fluttertoast.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() =>
      _PaymentPageState(); // comment out all same way//ok sir // run this
}

class _PaymentPageState extends State<PaymentPage> {
  static const platform = const MethodChannel("razorpay_flutter");
  bool enable = false;
  Razorpay _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (enable == true) {
        setState(() {
          enable = false;
        });
      }
    });
    openCheckout();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 100,
      'name': 'EasyJob',
      'description': 'Payment to apply for this job',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return JobList();
  }
}

/* import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Razorpay extends StatefulWidget {
  @override
  _RazorpayState createState() => _RazorpayState();
}

class _RazorpayState extends State<Razorpay> {
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Success');
    Fluttertoast.showToast(msg: 'Payment Success');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Failed');
    Fluttertoast.showToast(msg: 'Payment Failure');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet Selected');
    Fluttertoast.showToast(msg: 'External Wallet');
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_Kh6Gu1rWhL4ctF",
      "amount": 100,
      "currency": "INR",
      "name": "RazorPay",
      "description": "Payment for applying job",
      "prefill": {"contact": "2323232323", "email": "shdjsdh@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            width: width,
            height: height,
            child: GestureDetector(
              onTap: () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            'Would you like to pay now to apply for this job?'),
                        actions: [
                          GestureDetector(
                            onTap: null,
                            child: Text(
                              'NO',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              openCheckout();
                            },
                            child: Text(
                              'YES',
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                        ],
                      );
                    });
              },
              child: Text('pay'),
            )));
  }
}


 */
