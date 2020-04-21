import 'package:student_app/pojos/basic.dart';
import 'package:student_app/screens/PackageList.dart';
import 'package:flutter/material.dart';

class PackageHomeScreen extends StatelessWidget {
  StudentUser user = StudentUser();
  PackageHomeScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packages'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Image.asset(
              "assets/package.png",
              height: MediaQuery.of(context).size.height * 0.045,
            ),
            title: Text(
              'My Packages',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Divider(
              color: Colors.orange,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PackageList(user, true)));
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/package.png",
              height: MediaQuery.of(context).size.height * 0.045,
            ),
            title: Text(
              'All Packages',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Divider(
              color: Colors.orange,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PackageList(user, false)));
            },
          )
        ],
      ),
    );
  }
}
