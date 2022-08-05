import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:record_video_playback/views/camer_screen.dart';
import 'package:record_video_playback/views/video_view.dart';
import 'package:video_player/video_player.dart';

class RecordingScreen extends StatefulWidget {
  RecordingScreen({Key? key, required this.thumbnailfile, required this.file})
      : super(key: key);

  Uint8List? thumbnailfile;
  File? file;
  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  @override
  void initState() {
    print(widget.thumbnailfile);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // widget.videoController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.grey,
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: MaterialButton(
                  minWidth: 200,
                  color: Colors.lightGreen,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            //VideoView(file: widget.file)
                            builder: (context) => CameraScreen()));
                  },
                  child: const Text("Page1"),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoView(
                                file: widget.file,
                                thumbnailfile: widget.thumbnailfile,
                              )));
                },
                color: Colors.red,
                minWidth: 200,
                child: const Text('Page2'),
              )
            ],
          ),
        ),
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: const Center(
            child: Text("Record&Play"),
          ),
        ),
        body: SizedBox(
            height: height,
            width: width,
            child: Center(
              child: Text(" "),
            )
            // widget.thumbnailfile == null
            //     ? GestureDetector(
            //         onTap: () {
            //           // Navigator.push(
            //           //     context,
            //           //     MaterialPageRoute(
            //           //         builder: (context) => CameraScreen()));
            //         },
            //         child: ClipRect(
            //           child: SizedBox(
            //             width: width / 2,
            //             height: height / 2,
            //             child: Image.asset(
            //               'assest/images/imageplaceholder.jpg',
            //               fit: BoxFit.fitHeight,
            //               height: height / 2,
            //             ),
            //           ),
            //         ))
            //     : GestureDetector(
            //         onLongPress: () {
            //           Navigator.pushReplacement(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => CameraScreen()));
            //         },
            //         child: SizedBox(
            //             width: width / 2,
            //             height: height / 2,
            //             child: Image.memory(widget.thumbnailfile!)),
            //       ),
            ));
  }
}
