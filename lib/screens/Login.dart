import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:student_app/screens/ChangePasswordOTP.dart';
import 'package:student_app/screens/HomeScreen.dart';
import 'package:student_app/screens/RegisterScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
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
                      height: MediaQuery.of(context).size.height * 0.09),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Padding(
                padding: const EdgeInsets.only(left: 45, right: 45,bottom: 20),
                child: TextField(
                  controller: usernameController,
                    keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Phone Number"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45, right: 45,bottom: 60),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Password"),
                ),
              ),
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(22),
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.blue,
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () async{
                      String username = usernameController.text;
                      String password = passwordController.text;
                      if (username == null ||
                          username == '' ||
                          password == null || password == '') {
                        Fluttertoast.showToast(
                            msg: 'Please fill all the fields');
                      } else {
                        showLoaderDialog(context);
                          StudentUser studentUser = await studentLogin(username.toString().replaceAll("\ ", ''),password.toString().replaceAll("\ ", ""));
                             if (studentUser == null) {
                        Fluttertoast.showToast(
                            msg: "invalid user name and password",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 2,
                            textColor: Colors.red,
                            fontSize: 20.0);
                            Navigator.pop(context);
                      }
                      else {
                            SharedPreferences prefs = await preferences;
                          prefs.setString('userkey',studentUser.key);
                           prefs.setString('institute',studentUser.institute);
                           prefs.setString('username',studentUser.username);
                          prefs.setString('name',studentUser.name);
                            Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(studentUser)));
                      }

                      }




                    }),
              ),

              Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account ?',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Register',
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 18),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                           Navigator.push(context,
                              MaterialPageRoute(builder: (context) => SignupPage()));
                                   
                                  })
                          ]),
                    ),
                  )),
    Padding(
                padding: EdgeInsets.only(top: 100),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text('Forgot Password? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordOTP()));
                      },
                      child: Text(
                        'Change Password',
                        style: TextStyle(color: Colors.orange),
                      ),
                    )
                  ],
                ),
              ),
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
