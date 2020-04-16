import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayScreen extends StatefulWidget {
  StudentUser user;
  double amount;
  var packageId;
  RazorPayScreen(this.user, this.packageId,this.amount);
  @override
  State<StatefulWidget> createState() {
    return _RazorPayScreen(user, amount);
  }
}

class _RazorPayScreen extends State<RazorPayScreen> {
  StudentUser user;
  double totalAmount;
  _RazorPayScreen(this.user, this.totalAmount);
  Razorpay razorpay;

  void openCheckOut() async {
    var options = {
      'key': 'rzp_live_3hgrubxInUC0uV',
      'amount': totalAmount * 100,
      'name': 'Bodhi AI',
      'description': 'Buy Package',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        //  'wallets': ['paytm']
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await studentBuyPackage(user.key, widget.packageId, totalAmount);
    Fluttertoast.showToast(msg: "Success" + response.paymentId);
    Navigator.pop(context);
  }

  _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Failed" + response.code.toString() + ' ' + response.message);
  }

  // _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
        // msg: "External Wallet" + response.walletName.toString());
  // }

  @override
  void initState() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    //razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Package'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              LimitedBox(
                child: Text(totalAmount.toString()),
              ),
              RaisedButton(
                color: Colors.black,
                child: Text(
                  'Buy Package',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  openCheckOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
