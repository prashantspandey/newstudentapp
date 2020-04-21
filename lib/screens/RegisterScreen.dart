import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/Login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_app/screens/OTPRegister.dart';
import '../helpers/app_settings.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String instituteCode = INSTITUTE_CODE;
  @override
  void initState() {
    super.initState();
  }

  showLoader(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/logo.png",
                      height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Padding(
                padding: const EdgeInsets.only(left: 45, right: 45, bottom: 20),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: "Full Name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45, right: 45, bottom: 20),
                child: TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Phone Number"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45, right: 45, bottom: 60),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Password"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.blue,
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      String username = usernameController.text;
                      String password = passwordController.text;
                      String name = nameController.text;
                      if (username.length != 10 ||
                          name == null ||
                          username == '' ||
                          name == '') {
                        Fluttertoast.showToast(
                            msg:
                                'Please fill all the fields or enter proper number');
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return RequestBatch(
                                  instituteCode, name, username, password);
                            });
                      }
                    }),
              ),
              Container(
                  // width: MediaQuery.of(context).size.width*0.8,
                  // color: Colors.red,
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text:
                              'By signing up , you confirm that you have\n read and agree to the ',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Terms and Conditions\n',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: "                    "),
                            TextSpan(
                              text: 'and ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            )
                          ]),
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'Already have an account?',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Login',
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 18),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  })
                          ]),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var controllpoint = Offset(50, size.height);
    var endpoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controllpoint.dx, controllpoint.dy, endpoint.dx, endpoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class RequestBatch extends StatefulWidget {
  String instituteCode;
  String name;
  String username;
  String password;
  RequestBatch(this.instituteCode, this.name, this.username, this.password);
  @override
  State<StatefulWidget> createState() {
    return _RequestBatch(instituteCode);
  }
}

class _RequestBatch extends State<RequestBatch> {
  String instituteCode;
  _RequestBatch(this.instituteCode);
  var batches = [];
  getBatches() async {
    var response = await batchesBeforeRegistration(instituteCode);
    var bats = response['batches'];
    for (var ba in bats) {
      var baDict = {'id': ba['id'], 'name': ba['name'], 'value': false};
      setState(() {
        batches.add(baDict);
      });
    }

    return response;
  }

  @override
  void initState() {
    super.initState();
    getBatches();
  }

  @override
  void dispose() {
    super.dispose();
  }
showLoader(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text('Select your course/batch',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
            ),
            batches == null || batches.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: batches.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CheckboxListTile(
                          title: Text(batches[index]['name']),
                          value: batches[index]['value'],
                          onChanged: (bool value) {
                            setState(() {
                              batches[index]['value'] = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                height: 50,
                minWidth: MediaQuery.of(context).size.width - 50,
                child: RaisedButton(
                  color: Colors.black,
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    var sendBatches = [];
                    for (var ba in batches) {
                      if (ba['value'] == true) {
                        sendBatches.add(ba['id']);
                      }
                    }
                    if (sendBatches.length != 0) {
                      var response =
                          await checkUsernameExitance(widget.username);
                      if (response['exist'] == true) {
                        Fluttertoast.showToast(
                            msg:
                                ' Phone number already registered.You can login with this number.');
                        Navigator.pop(context);
                      } else {
                        showLoader(context);
                        Fluttertoast.showToast(msg: 'Sending OTP');
                        var response = await changePasswordOTP(widget.username);
                        Navigator.pop(context); 
                        if (response['status'].toString() == '200') {
                          var otp = response['otp'];
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OTPRegister(
                                      otp,
                                      widget.username,
                                      widget.name,
                                      widget.password,
                                      widget.instituteCode,
                                      sendBatches)));
                        } else {
                          Fluttertoast.showToast(msg: response['message']);
                        }
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please select atleast one batch/course.');
                    }

                    print('register');
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
