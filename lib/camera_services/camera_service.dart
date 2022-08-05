import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_video_playback/views/playback_screen.dart';
import 'package:record_video_playback/views/record_it.dart';

class CameraService {
  var timer;
  Future<void> startVideoRecorder(
      cameracontrolled, BuildContext context) async {
    final CameraController? cameraController = cameracontrolled;

    if (cameraController!.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      print('recording');
      return;
    }
    try {
      timer = Timer.periodic(const Duration(seconds: 20), (Timer t) {
        // _onStopButtonPressed();
        CameraService().stopVideoRecorder(cameraController, context);
        t.cancel();
      });
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  Future<File?> stopVideoRecorder(
      cameracontrolled, BuildContext context) async {
    if (!cameracontrolled.value.isRecordingVideo) {
      return null;
    }

    try {
      print('Stopping');
      XFile RecordFile = await cameracontrolled.stopVideoRecording();
      if (timer != null) {
        timer.cancel;
      }
      print(RecordFile.name);
      File videoFile = File(RecordFile.path);
      // RecordingScreen().file = videoFile;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PlaybackScreen(
                    file: videoFile,
                  )));
      return videoFile;
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }
}
