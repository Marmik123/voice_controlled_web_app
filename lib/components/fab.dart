import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:voicewebapp/components/snack_bar.dart';

class FAB extends StatefulWidget {
  // const FAB({Key? key}) : super(key: key);
  final controller;

  const FAB({Key? key, this.controller}) : super(key: key);
  @override
  _FABState createState() => _FABState();
}

enum micState {
  start,
  stop,
  none,
}

late FlutterSoundRecorder recorder;

class _FABState extends State<FAB> {
  dynamic? bytes;
  String? path;
  late micState buttonState;
  RxBool recordStart = true.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonState = micState.none;
    recorder = FlutterSoundRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => recordStart()
        ? FloatingActionButton(
            onPressed: () {
              onRecord();
              recordStart(false);
            },
            tooltip: 'Start Listening',
            child: micBtn(micState.stop),
          )
        : FloatingActionButton(
            onPressed: () {
              onStop();
              recordStart(true);
              // print(recordStart());
            },
            tooltip: 'Stop Listening',
            child: micBtn(micState.start),
          ));
  }

  Future<void> sendBytesToServer(dynamic bytes) async {
    print("SENDING BYTES CALLED");
    try {
      final response =
          await http.post(Uri.parse('http://127.0.0.1:5000/processaudio'),
              headers: {
                'Content-Type': 'application/json',
                "Access-Control-Allow-Origin":
                    "*", // Required for CORS support to work
                "Access-Control-Allow-Headers":
                    "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
                "Access-Control-Allow-Methods": "POST"
              },
              body: jsonEncode(
                <String, dynamic>{
                  'audioBytes': bytes,
                },
              ));
      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        if (!result['error']) {
          print('responseResult:${result['response']}');
          widget.controller.evaluateCommand(result['response']);
          // widget.controller.evaluateCommand('Add 5 watermelon to the basket');
        } else {
          appSnackbar(message: 'Command not recognized.');
        }
      } else {
        print('statusCode:${response.statusCode}');
      }
    } catch (e) {
      appSnackbar(message: 'Something went wrong,Please try again.');
      print(e);
    }
  }

  void onRecord() async {
    print('inside record');
    await recorder.openRecorder();
    await recorder.startRecorder(toFile: 'foo');
    print(Codec.defaultCodec);
  }

  void onStop() async {
    print('ONSTOP');
    var path = await recorder.stopRecorder();
    final result = await http.get(Uri.parse(path!));
    var bytes = result.bodyBytes;
    // print(bytes);
    sendBytesToServer(bytes);
  }
}

Widget micBtn(
  micState buttonState,
) {
  switch (buttonState) {
    case micState.start:
      return Padding(
        padding: EdgeInsets.all(25.r),
        child: const AvatarGlow(
          endRadius: 25,
          animate: true,
          duration: Duration(milliseconds: 2000),
          glowColor: Colors.white,
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: Duration(milliseconds: 50),
          child: Icon(Icons.mic_off),
        ),
      );
    case micState.stop:
      return Padding(
        padding: EdgeInsets.all(25.r),
        child: GestureDetector(child: const Icon(Icons.mic)),
      );
    default:
      return Padding(
        padding: EdgeInsets.all(25.r),
        child: const Icon(Icons.mic),
      );
  }
}
