import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:record_video_playback/camera_services/camera_service.dart';

import '../main.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({Key? key}) : super(key: key);
  bool isstarted = false;
  bool camerastart = false;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController cameracontrolled;

  @override
  void initState() {
    // TODO: implement initState
    widget.isstarted = false;
    widget.camerastart = false;
    super.initState();
    cameracontrolled = CameraController(cameras[0], ResolutionPreset.high);

    cameracontrolled.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    //  var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          child: widget.camerastart == true
              ? ListView(
                  children: [
                    Align(
                      child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: CameraPreview(cameracontrolled)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: MaterialButton(
                            minWidth: 30,
                            height: 40,
                            color: widget.isstarted == true
                                ? Colors.red
                                : Colors.green,
                            onPressed: () async {
                              await CameraService().startVideoRecorder(
                                  cameracontrolled, context);

                              //  widget.isstarted = true;

                              if (widget.isstarted == true) {
                                widget.isstarted = false;
                                await CameraService().stopVideoRecorder(
                                    cameracontrolled, context);
                              } else {
                                widget.isstarted = true;
                              }
                              setState(() {});
                            },
                            child: widget.isstarted == true
                                ? const Text('Stop Recording')
                                : const Text('Start Recording'),
                          ),
                        ),

                        // Flexible(
                        //   flex: 2,
                        //   child: MaterialButton(
                        //     minWidth: 20,
                        //     height: 40,
                        //     color: Colors.red,
                        //     onPressed: () async {
                        //       await CameraService()
                        //           .stopVideoRecorder(cameracontrolled, context);
                        //     },
                        //     child: const Text('Stop Recording'),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: widget.isstarted == true
                          ? Center(
                              child: TimerCountdown(
                                format: CountDownTimerFormat.secondsOnly,
                                endTime: DateTime.now()
                                    .add(const Duration(seconds: 20)),
                              ),
                            )
                          : const Center(child: Text('Status Not started')),
                    )
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    widget.camerastart = true;
                    setState(() {});
                  },
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 50,
                    ),
                  ))),
    );
  }
}
