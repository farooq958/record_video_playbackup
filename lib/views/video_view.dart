import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:record_video_playback/views/camer_screen.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  VideoView({Key? key, required this.file, required this.thumbnailfile})
      : super(key: key);
  File? file;
  VideoPlayerController? videoController;
  bool? check;
  Uint8List? thumbnailfile;
  Timer? timer;
  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  void initState() {
    // TODO: implement initState
    widget.check = false;
    if (widget.file != null) {
      // widget.file2 = widget.file;
      // print(widget.file!.path);

      widget.videoController = VideoPlayerController.file(widget.file!)
        ..initialize().then((_) {
          //    widget.check = true;
          //widget.videoController.Play();
          //widget.videoController.Play();
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

          setState(() {});
        });
      // widget.videoController!.setLooping(true);
      //  widget.videoController?.play();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        height: height * 0.69,
        // color: Colors.red,
        child: widget.videoController == null
            ? Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 400,
                  height: 600,
                  child: Image.asset(
                    'assest/images/imageplaceholder.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
            : widget.check == false
                ? GestureDetector(
                    onTap: () {
                      // print(widget.videoController!.value.duration
                      //     .abs()
                      //     .toString());

                      // If the video is paused, play it.
                      widget.videoController?.play();
                      widget.check = true;
                      widget.timer = Timer.periodic(
                          widget.videoController!.value.duration, (Timer t) {
                        // _onStopButtonPressed();
                        // CameraService().stopVideoRecorder(cameraController, context);

                        widget.videoController
                            ?.seekTo(const Duration(seconds: 0));
                        widget.videoController?.pause();
                        widget.check = false;
                        t.cancel();
                        //  widget.timer?.cancel();
                        if (!mounted) return;
                        setState(() {});
                      });

                      // widget.videoController?.setLooping(true);
                      setState(() {});
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onLongPress: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CameraScreen()));
                              },
                              child: Image.memory(
                                widget.thumbnailfile!,
                                width: 400,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.grey,
                                size: 70,
                              ))
                        ],
                      ),
                    ))
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: ListView(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            //  widget.videoController!.pause();
                            widget.timer?.cancel();
                            await widget.videoController
                                ?.seekTo(const Duration(seconds: 0));
                            await widget.videoController?.pause();
                            widget.check = false;
                            setState(() {});
                          },
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AspectRatio(
                                aspectRatio: 3 / 4,
                                child: VideoPlayer(widget.videoController!)),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
