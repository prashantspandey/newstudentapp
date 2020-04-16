import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/ChangePassword.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordOTP extends StatelessWidget {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send OTP'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: phoneController,
                  obscureText: false,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: "Phone Number/Username",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)))),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              color: Colors.black,
                  child: Text('Send OTP',style: TextStyle(color: Colors.white),),
                  onPressed: () async {
                    var response = await changePasswordOTP(phoneController.text);
                    if(response['status'].toString()=='200'){
                      Fluttertoast.showToast(msg: 'OTP send to your phone');
                      var otp = response['otp'];
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangePassword(phoneController.text,otp)));

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
