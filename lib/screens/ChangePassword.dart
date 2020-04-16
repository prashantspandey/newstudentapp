import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  var phoneNumber;
  var otp;
  ChangePassword(this.phoneNumber, this.otp);
  @override
  State<StatefulWidget> createState() {
    return _ChangePassword();
  }
}

class _ChangePassword extends State<ChangePassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController otpController = TextEditingController();


  showLoaderDialog(context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              'Username/Phone: ' + widget.phoneNumber,
              style: TextStyle(fontSize: 25),
            ),
            TextField(
                controller: otpController,
                obscureText: false,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    hintText: "OTP",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)))),
            TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)))),
            TextField(
                controller: passwordConfirmController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Confirm Password",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)))),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.black.withOpacity(0.95),
                  child: Text(
                    'Change Password',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    showLoaderDialog(context);
                    if (otpController.text == widget.otp.toString().replaceAll("\ ", "")) {
                      if (passwordController.text ==
                          passwordConfirmController.text) {
                        var response = await changePassword(
                            widget.phoneNumber, passwordController.text);
                        if (response['status'] == 'Success') {
                          Fluttertoast.showToast(
                              msg:
                                  'Password Changed successfully ! Login with new password.');
                                  Navigator.pop(context);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        } else {
                                  Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: 'Wrong OTP. Please enter again.');
                        }
                      }
                    } else {
                                  Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: 'Wrong OTP. Please try again ${widget.otp}');
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}