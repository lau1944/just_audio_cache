import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AudioPlayer _player;
  final url = 'https://www.mboxdrive.com/m54.mp3';
  PlayerState? _state;

  @override
  void initState() {
    _player = AudioPlayer();
    _player.dynamicSet(url: url);
    _player.playerStateStream.listen((state) {
      setState(() {
        _state = state;
      });
      print(state);
    });
    super.initState();
  }

  void _playAudio() async {
    _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Center(
          child: _audioStateWidget(),
        ),
      ),
    );
  }

  Widget _audioStateWidget() {
    if (_state == null) return _playButton;

    if (_state!.playing) {
      return _pauseButton;
    } else {
      return _playButton;
    }
  }

  Widget get _pauseButton => ElevatedButton(
        onPressed: () {
          _player.pause();
        },
        child: Text('Pause'),
      );

  Widget get _playButton => ElevatedButton(
        onPressed: () {
          _playAudio();
        },
        child: Text('Play'),
      );
}
