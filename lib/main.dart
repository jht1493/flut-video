import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  static const myTitle = 'Video Explore 5';
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  var moviePaths = [
    'https://jht1493.net/macr/insta/1-Welcome-to-Instigate-Jaxon.mp4',
    'https://jht1493.net/macr/insta/1-Welcome-to-Instigate-pete4.mp4',
    'https://jht1493.net/macr/insta/2-Media-chip.mp4',
    'https://jht1493.net/macr/insta/2-plus-sign.mp4',
    'https://jht1493.net/macr/insta/beings-defined.mp4',
    'https://jht1493.net/macr/insta/bella-placeholder.mp4',
    'https://jht1493.net/macr/insta/canterfamilysingers.mov',
    'https://jht1493.net/macr/insta/demo-video-3.mp4',
    'https://jht1493.net/macr/insta/french-dip.mp4',
    'https://jht1493.net/macr/insta/NewIntro-final-noaudio.m4v',
    'https://jht1493.net/macr/insta/opening-guess-what.mp4',
    'https://jht1493.net/macr/insta/something-2-do-w-money.mp4',
    'https://jht1493.net/macr/insta/that-s-right.mp4',
    'https://jht1493.net/macr/insta/what-about.mp4',
    'https://jht1493.net/macr/insta/Who-are-the-Grateful-Dead-6.mp4',
    'https://jht1493.net/macr/insta/Who-are-the-Grateful-Dead-authenticity.mp4',
  ];
  var moviePaths2 = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://jht1493.net/macr/mov/sample_640x360.mp4',
    // 'https://jht1493.net/macr/mov/sample_960x400_ocean_with_audio.mp4',
    // 'https://jht1493.net/macr/mov/sample_1280x720_surfing_with_audio.mp4',
    // 'https://jht1493.net/macr/mov/sample_960x540.mp4',
    // 'https://jht1493.net/macr/mov/sample_1280x720.mp4',
    // 'https://jht1493.net/macr/mov/sample_1920x1080.mp4',
    // 'https://jht1493.net/macr/mov/002831_HD_COUNTDOWN_03-480p.mov',
    // 'https://jht1493.net/macr/mov/002831_HD_COUNTDOWN_03.mov',
  ];
  String moviePath = '';
  int _counter = 0;
  bool startedPlaying = false;
  bool stopSeen = false;
  bool playPending = false;
  bool playAll = false;

  @override
  void initState() {
    print('_VideoPlayerScreenState initState');
    setupMoviePath();
    super.initState();
  }

  void setupMoviePath() {
    moviePath = moviePaths[_counter];
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(moviePath);
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      // print( '!!@ addListener startedPlaying=$startedPlaying');
      // print(' isPlaying=${_controller.value.isPlaying}');
      // print(' stopSeen=${stopSeen}');
      if (startedPlaying && !_controller.value.isPlaying && !stopSeen) {
        print('!!@ video stopped pos=${_controller.value.position}');
        print('_counter=$_counter');
        stopSeen = true;
        if (playAll) {
          _adjustCounter(1);
          playPending = true;
        }
      }
    });
    startedPlaying = false;
    stopSeen = false;
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  void _adjustCounter(int delta) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = (_counter + delta + moviePaths.length) % moviePaths.length;
      _controller.dispose();
      setupMoviePath();
    });
  }

  void _startPlayAll() {
    print('_startPlayAll playAll=$playAll');
    if (!_controller.value.isPlaying) {
      togglePlay();
    }
    playAll = true;
    playPending = true;
    // _adjustCounter(0);
  }

  void _stopPlayAll() {
    print('_stopPlayAll playAll=$playAll');
    if (_controller.value.isPlaying) {
      togglePlay();
    }
    playAll = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(myTitle),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: futureBuilder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: togglePlay,
        // Display the correct icon depending on the state of the player.
        child: playingIcon(),
      ),
    );
  }

// (new) Icon Icon(IconData? icon, { Key? key, double? size, Color? color,
//        String? semanticLabel, TextDirection? textDirection })
  Icon playingIcon() {
    return Icon(
      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
    );
  }

  // {required void Function()? onPressed}
  void togglePlay() {
    // print('togglePlay');
    setState(() {
      // If the video is playing, pause it.
      if (_controller.value.isPlaying) {
        _controller.pause();
        startedPlaying = false;
        stopSeen = false;
        playPending = false;
      } else {
        // If the video is paused, play it.
        _controller.play();
        startedPlaying = true;
        stopSeen = false;
        playPending = false;
      }
    });
  }

  // {required Widget Function(BuildContext, AsyncSnapshot<void>) builder}
  Widget futureBuilder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return buildVideoPlayerUI();
    } else {
      // If the VideoPlayerController is still initializing, show a loading spinner.
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget buildVideoPlayerUI() {
    // print('done');
    // _controller.setLooping(true);
    // _controller.play();
    if (playPending && !_controller.value.isPlaying) {
      _controller.play();
      startedPlaying = true;
      playPending = false;
      stopSeen = false;
      // togglePlay();
    }
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ButtonBar(alignment: MainAxisAlignment.start, children: <Widget>[
            TextButton(
              child: const Text('Prev '),
              onPressed: () {
                // print('Button Next');
                _adjustCounter(-1);
              },
            ),
            TextButton(
              child: const Text('Next '),
              onPressed: () {
                // print('Button Next');
                _adjustCounter(1);
              },
            ),
            TextButton(
              child: const Text('Play All '),
              onPressed: () {
                // print('Button Next');
                _startPlayAll();
              },
            ),
            TextButton(
              child: const Text('Stop All '),
              onPressed: () {
                // print('Button Next');
                _stopPlayAll();
              },
            ),
          ]),
          Text(videoInfoStr()),
          ValueListenableBuilder(
              valueListenable: _controller, builder: buildValuesDisplay),
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            // Use the VideoPlayer widget to display the video.
            child: VideoPlayer(_controller),
          ),
        ],
      ),
    );
  }

  String videoInfoStr() {
    var ms = moviePath.split('/');
    var tx = ms[ms.length - 1];
    return 'Index=$_counter File=$tx';
  }

  // Widget Function(BuildContext, VideoPlayerValue, Widget?) builder
  Widget buildValuesDisplay(
      BuildContext context, VideoPlayerValue value, Widget? child) {
    var str = value.position.toString();
    str = str.substring(0, str.length - 4);
    var dur = value.duration.toString();
    dur = dur.substring(0, dur.length - 4);
    var size = value.size.toString();
    return Text('pos=' + str + ' dur=' + dur + ' ' + size);
  }
}

// https://stackoverflow.com/questions/60249930/how-to-show-current-play-time-of-video-when-using-video-player-plugin-in-flutter
