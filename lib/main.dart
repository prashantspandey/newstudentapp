import 'package:student_app/pojos/basic.dart';
import 'package:student_app/screens/HomeScreen.dart';
import 'package:student_app/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/screens/RegisterScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  getPreferences() async{
  bool isLoggedIn;
  StudentUser studentUser;

    SharedPreferences prefs = await preferences;
    var key = prefs.getString('userkey');
    var institute = prefs.getString('institute');
    var username = prefs.getString('username');
    var name = prefs.getString('name');
    if (key != null){
        isLoggedIn =true;
        var userJson = {'key':key,'institute':institute,'username':username,'name':name};
        studentUser = StudentUser.fromJson(userJson);

    }
    else{
      isLoggedIn = false;
    }
  return [isLoggedIn,studentUser];
  }
    @override
  void initState() {
    super.initState();
    //getPreferences();
    
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Prestige Point',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(future: getPreferences(), builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data !=null){
              bool loggedIn = snapshot.data[0];
              var user = snapshot.data[1];
              return loggedIn?HomeScreen(user):SignupPage();
          }
          else{
            return Center(child: CircularProgressIndicator(),);
          }
        },));
  }
}
