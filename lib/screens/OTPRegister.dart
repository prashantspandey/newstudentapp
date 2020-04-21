import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/Login.dart';
import 'package:student_app/screens/RegisterScreen.dart';

class OTPRegister extends StatefulWidget {
  var otp;
  var phoneNumber;
  String name;
  String password;
  String instituteCode;
  List sendBatches;

  OTPRegister(this.otp, this.phoneNumber, this.name, this.password,
      this.instituteCode, this.sendBatches);

  @override
  _OTPRegisterState createState() => _OTPRegisterState();
}

class _OTPRegisterState extends State<OTPRegister> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register OTP'),
        backgroundColor: Colors.pink,
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Phone Number: ' + widget.phoneNumber.toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: otpController,
              decoration: InputDecoration(hintText: 'OTP'),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width - 100,
              child: RaisedButton(
                  color: Colors.pink,
                  child: Text('Register'),
                  onPressed: () async {
                    if (otpController.text.toString() ==
                        widget.otp.toString()) {
                      var response = await studentRegister(
                          widget.name,
                          widget.phoneNumber,
                          widget.password,
                          widget.instituteCode,
                          widget.sendBatches);
                      if (response['status'] == 'Success') {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                        Fluttertoast.showToast(
                            msg:
                                'Successfully Registered !! Now login using your phone and password.');
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'OTP did not match.Go back and try again.');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage()));
                    }
                  }),
            ),
          )
        ],
      )),
    );
  }
}
