import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_app/pojos/basic.dart';
import 'package:student_app/requests/request.dart';
import 'package:wakelock/wakelock.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;
  final String APP_ID;
  final StudentUser user;
  final int videoId;

  /// Creates a call page with given channel name.
  const CallPage(this.APP_ID,this.user,this.videoId,{Key key, this.channelName}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState(APP_ID,channelName);
}

class _CallPageState extends State<CallPage> {
  TextEditingController messageController = TextEditingController();
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  String APP_ID;
  String channelName;
 //   List<String> messages = [];
//    ScrollController _scrollController = ScrollController();
  _CallPageState(this.APP_ID,this.channelName);

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
     leaveLiveVideo(widget.user.key,widget.videoId,DateTime.now());
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    Wakelock.enable();
  }

  Future<void> initialize() async {
    // if (APP_ID.isEmpty) {
    //   setState(() {
    //     _infoStrings.add(
    //       'APP_ID missing, please provide your APP_ID in settings.dart',
    //     );
    //     _infoStrings.add('Agora Engine is not starting');
    //   });
    //   return;
    // }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
 AgoraRtcEngine.setParameters('{\"che.video.lowBitRateStreamParameter\":{\"width\":160,\"height\":120,\"frameRate\":15,\"bitRate\":130},{\"che.video.keep_prerotation\":false},{\"che.video.local.camera_index\":1025}}');
   // AgoraRtcEngine.setParameters("{\"rtc.log_filter\": 65535}"); 
        await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
        await AgoraRtcEngine.setClientRole(ClientRole.Audience);
        
  //  VideoEncoderConfiguration config = VideoEncoderConfiguration();
  //  config.degradationPreference = DegradationPreference.MaintainQuality;
  //  config.dimensions =  Size(640, 360);
  //  config.frameRate = 15;
  //  config.orientationMode = VideoOutputOrientationMode.FixedLandscape;
  //  config.bitrate = 800;
  // await AgoraRtcEngine.setVideoEncoderConfiguration(config);

    await AgoraRtcEngine.joinChannel(null, channelName, null, 0);
  }
  /// Create agora sdk instance and initialize
  // Future<void> _initAgoraRtcEngine() async {
    // await AgoraRtcEngine.create(APP_ID);
    // await AgoraRtcEngine.enableVideo();
  // }
 Future<void> _initAgoraRtcEngine() async {

    await AgoraRtcEngine.create(APP_ID);
   await AgoraRtcEngine.enableVideo();


    //AgoraRtcEngine.create('xxxxxxxxxxxxxxxxxxxxxxxxx');
    // await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // await AgoraRtcEngine.setClientRole(ClientRole.Audience);
    // await AgoraRtcEngine.enableWebSdkInteroperability(true);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid 300x 300';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List _getRenderViews() {
    List<AgoraRenderWidget> list = List();
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
}
  // List _getRenderViews() {
        // final List<AgoraRenderWidget> list = [
      // AgoraRenderWidget(0, local: false, preview: false),
    // ];
    // _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    // print('user list ${list.toString()}');
    // return list;
// }
  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }
  // Widget _viewRows2() {
    // final views = _getRenderViews();
        // return Column(
          // children: <Widget>[_videoView(views[1])],
        // );
    // }
  // Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    print('length views ${views.length.toString()}');
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  /// 
  Widget _sendMessage(){
    return Container(
      child: Column(
       mainAxisAlignment: MainAxisAlignment.end, 
        children: <Widget>[
      TextField(controller:messageController,decoration: InputDecoration(hintText: 'Ask a question !'),),
      ButtonTheme(
        minWidth: MediaQuery.of(context).size.width-10,
              child: RaisedButton(child: Text('Send',style: TextStyle(color: Colors.white),),color: Colors.black, onPressed: () async {
                if(messageController.text != null || messageController.text != ''){
         var response = await agoraSendMessage(widget.user.key,messageController.text,widget.videoId);
         messageController.text = '';
         if (response['status']=='Success'){
         Fluttertoast.showToast(msg: 'Message sent !');
         }
         else{
         Fluttertoast.showToast(msg: response['message']);

         }
         

                }
                else{
                  Fluttertoast.showToast(msg: "Please enter a message.");
                }
        },),
      )
    ],),);
  }
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            //_panel(),
            //_toolbar(),
           _sendMessage(),
          ],
        ),
      )));  }
}
