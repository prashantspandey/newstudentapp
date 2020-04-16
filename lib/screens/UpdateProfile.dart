// import 'dart:convert';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:async/async.dart';
// import 'package:http/http.dart' as http;
//import 'package:test/test.dart';
// import 'package:amazon_cognito_identity_dart/sig_v4.dart';
// import 'package:student_app/pojos/basic.dart';
// import '../helpers/uploadPolicy.dart';
// import 'package:flutter/material.dart';
// 
// class UploadProfile extends StatefulWidget {
  // StudentUser user = StudentUser();
  // UploadProfile(this.user);
  // @override
  // State<StatefulWidget> createState() {
    // return _UploadProfile(user);
  // }
// }
// 
// class _UploadProfile extends State<UploadProfile> {
  // StudentUser user = StudentUser();
  // File _image;
  // _UploadProfile(this.user);
  // Future getImage() async {
    // print('in get image;');
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);
// 
    // setState(() {
      // _image = image;
    // });
  // }
// 
  // fileUpload(filePath) async {
    //filePath = filePath.toString().replaceAll(" ", "");
    // const _accessKeyId = 'AKIAS3H7C4UADYMMJEV7';
    // const _secretKeyId = '2s3lOdfrvfcEeRf+I3SYbV9uMmyrNdtSKwVm8RQb';
    // const _region = 'us-east-1';
    // const _s3Endpoint = 'https://instituteimages.s3.amazonaws.com';
// 
    // final file = File(filePath);
    // final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    // final length = await file.length();
// 
    // final uri = Uri.parse(_s3Endpoint);
    // print('uri ${uri.toString()}');
    // var body = {'filename':'flutterfile'};
    // var response = await http.post('http://15.206.150.90/api/content/file_policy_api/',body: body);
    // print(response.body);
    // var policy = json.decode(response.body);
    // var url = policy['url'];
    // var filename = policy['filename'];
    // var repsonseUser = policy['user'];
    //var keyPath = 'www/' + repsonseUser + '/' + filename
    // var keyPath = policy['file_bucket_path'];
    // var fd = Map<String,dynamic>();
    // fd['key'] =  keyPath + filename;
    // fd['acl'] =  'private';
    // fd['AWSAccessKeyId'] =  policy['key'];
    // fd['Policy'] =  policy['policy'];
    // fd['filename'] =  filename;
    // fd['Signature'] =  policy['signature'];
    // fd['file'] =  file.path;
    // print(fd);
    // var re = await http.post(url=policy['url'],body: fd);
    // print(re.body);
//  
    // final req = http.MultipartRequest("POST", uri);
    // final multipartFile = http.MultipartFile('file', stream, length,
    //     filename: path.basename(file.path));

    // final policy = Policy.fromS3PresignedPost(
    //     filePath, 'instituteimages', _accessKeyId, 15, length,
    //     region: _region);
    // final key =
    //     SigV4.calculateSigningKey(_secretKeyId, policy.datetime, _region, 's3');
    // final signature = SigV4.calculateSignature(key, policy.encode());
    // print('policy ${policy.credential.toString()}');
    // req.files.add(multipartFile);
    // print('multipart ${multipartFile.toString()}');
    // req.fields['key'] = policy.key;
    // req.fields['acl'] = 'public-read';
    // req.fields['X-Amz-Credential'] = policy.credential;
    // req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    // req.fields['X-Amz-Date'] = policy.datetime;
    // req.fields['Policy'] = policy.encode();
    // req.fields['X-Amz-Signature'] = signature;
    // try {
    //   final res = await req.send();
    //   print('res ${res.toString()}');
    //   await for (var value in res.stream.transform(utf8.decoder)) {
    //     print(value);
    //   }
    // } catch (e) {
    //   print(e.toString());
    // }
  // }
// 
  // @override
  // Widget build(BuildContext context) {
    // return Scaffold(
      // appBar: AppBar(
        // title: Text('Update Profile'),
      // ),
      // body: Container(
        // child: Column(
          // children: <Widget>[
            // RaisedButton(
              // child: Text('Upload Profile Picture'),
              // onPressed: () async{
                // await getImage();
                // fileUpload(_image.path);
              // },
            // )
          // ],
        // ),
      // ),
    // );
  // }
// }
// 