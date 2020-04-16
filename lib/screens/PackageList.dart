import 'package:student_app/pojos/basic.dart';
import 'package:student_app/screens/IndividualPackage.dart';
import 'package:flutter/material.dart';
import 'package:student_app/requests/request.dart';

class PackageList extends StatefulWidget {
  StudentUser user = StudentUser();
  bool bought;
  PackageList(this.user, this.bought);
  @override
  State<StatefulWidget> createState() {
    return _PackageList(user);
  }
}

class _PackageList extends State<PackageList> {
  StudentUser user = StudentUser();
  _PackageList(this.user);

  notBoughtPackages(key) async {
    var notBoughtPackages = await getNotBoughtPackages(key);
    return notBoughtPackages;
  }

  boughtPackages(key) async {
    var purchasedackages = await getBoughtPackages(key);
    return purchasedackages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Packages'), backgroundColor: Colors.orangeAccent),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: !widget.bought
                    ? notBoughtPackages(user.key)
                    : boughtPackages(user.key),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data != null) {
                    var packages = snapshot.data['packages'];
                    return ListView.builder(
                      itemCount: packages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                                                  child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/package.png",
                                height: MediaQuery.of(context).size.height * 0.045,
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                packages[index]['title'].replaceAll('\"', ''),
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height *
                                        0.022,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            trailing: Text('Valid for: ' +
                                packages[index]['duration'].toString() +
                                ' days',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text('Tests: ' +
                                      packages[index]['numberTests'].toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text('Videos: ' +
                                      packages[index]['numberVideos'].toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text('Notes: ' +
                                      packages[index]['numberNotes'].toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                              
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IndividualPackages(
                                          user,
                                          packages[index]['id'],
                                          packages[index]['bought'])));
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator(backgroundColor: Colors.deepOrange,));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
