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

  @override
  void initState() {
    _player = AudioPlayer();
    _player.setUrl(url);
    _player.playerStateStream.listen((state) {
      print(state);
    });
    super.initState();
  }

  void _playAudio() async {
    _player.playFromDynamic();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              _playAudio();
            },
            child: Text('Play'),
          ),
        ),
      ),
    );
  }
}
