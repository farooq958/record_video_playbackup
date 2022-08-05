import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_video_playback/views/record_it.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PlaybackScreen extends StatefulWidget {
  PlaybackScreen({Key? key, required this.file}) : super(key: key);
  VideoPlayerController? videoController;
  File? file;
  File? file2;
  Timer? timer;
  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  @override
  void initState() {
    // TODO: implement initState

    if (widget.file != null) {
      widget.file2 = widget.file;
      print(widget.file!.path);

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
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      child: ListView(
        children: [
          AspectRatio(
              aspectRatio: 3 / 4, child: VideoPlayer(widget.videoController!)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: MaterialButton(
                  minWidth: 30,
                  height: 40,
                  color: widget.videoController!.value.isPlaying
                      ? Colors.red
                      : Colors.green,
                  onPressed: () {
                    //  await widget.videoController?.play();

                    // If the video is playing, pause it.
                    if (widget.videoController!.value.isPlaying) {
                      widget.videoController?.pause();
                      widget.videoController
                          ?.seekTo(const Duration(seconds: 0));
                      widget.timer?.cancel();
                      // setState(() {});
                    } else {
                      // If the video is paused, play it.
                      widget.videoController?.play();

                      widget.timer = Timer.periodic(
                          widget.videoController!.value.duration, (t) {
                        // _onStopButtonPressed();
                        widget.videoController
                            ?.seekTo(const Duration(seconds: 0));
                        widget.videoController?.pause();
                        t.cancel();
                        if (!mounted) return;
                        setState(() {});
                      });
                      // setState(() {});
                    }

                    // widget.videoController?.setLooping(true);
                    setState(() {});
                  },
                  child: widget.videoController!.value.isPlaying
                      ? const Text('Stop')
                      : const Text('Play'),
                ),
              ),
              const Spacer(),
              Flexible(
                  flex: 3,
                  child: MaterialButton(
                    color: Colors.blueGrey,
                    minWidth: 20,
                    height: 40,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecordingScreen(
                                    thumbnailfile: null,
                                    file: null,
                                  )));
                    },
                    child: const Text("Cancel"),
                  )),
              const Spacer(),
              Flexible(
                flex: 3,
                child: MaterialButton(
                  minWidth: 20,
                  height: 40,
                  color: Colors.lightGreen,
                  onPressed: () async {
                    // widget.videoController?.pause();
                    bool? isSaved;
                    isSaved = await GallerySaver.saveVideo(widget.file!.path);
                    if (isSaved!) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Video Saved to Your Gallery")));

                      Uint8List? _thumbnailfile;
                      // Directory? Thumbnaildirec = await getTemporaryDirectory();

                      _thumbnailfile = await VideoThumbnail.thumbnailData(
                        video: widget.file2!.path,
                        // thumbnailPath: Thumbnaildirec.path,
                        imageFormat: ImageFormat.PNG,
                        maxWidth: 400,
                        maxHeight: 500,
                      );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecordingScreen(
                                    thumbnailfile: _thumbnailfile,
                                    file: widget.file2,
                                  )));
                      setState(() {});
                    }
                  },
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
