import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/HomeScreen.dart';

class BuyPackageScreen extends StatefulWidget {
  StudentUser user = StudentUser();
  int packageId;
  BuyPackageScreen(this.user, this.packageId);
  @override
  _BuyPackageScreenState createState() => _BuyPackageScreenState();
}

class _BuyPackageScreenState extends State<BuyPackageScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Package'),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              'Request to buy this package',
              style: TextStyle(fontSize: 20),
            )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: phoneNumberController,
                decoration: InputDecoration(hintText: 'Phone Number'),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: 50,
                child: RaisedButton(
                  color: Colors.black,
                  child: Text(
                    'Send request to teacher',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (phoneNumberController.text.length == 10) {
                      var rightNow = DateTime.now();
                      var response = await buyPackageRequest(
                          widget.user.key,
                          widget.packageId,
                          rightNow,
                          phoneNumberController.text);
                      if (response['status'] == 'Success') {
                        Fluttertoast.showToast(
                            msg:
                                "Request Sent !! You will soon be contacted by your teacher.");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      widget.user,
                                    )));
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Something went wrong ${response['messsage']}");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      widget.user,
                                    )));
                      }
                    } else {
                      Fluttertoast.showToast(msg: 'Please enter your number');
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
