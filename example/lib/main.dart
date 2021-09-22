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
  final sources = [
    'https://www.mboxdrive.com/m54.mp3',
    'https://www.mboxdrive.com/%c3%86STRAL%20-%20half%20light.mp3',
    'https://www.mboxdrive.com/%ca%8f%e1%b4%80%20%ca%99%e1%b4%9c%e1%b4%85%e1%b4%9c.mp3'
  ];
  PlayerState? _state;

  @override
  void initState() {
    _player = AudioPlayer();
    //_player.dynamicSet(url: url);
    _player.dynamicSetAll(sources);
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
