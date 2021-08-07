import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:just_audio_cache/src/parser.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('audio_test', () {
    test('test_cache_path', () async {
      final url = 'https://baidu.com/hello/world.mp3';
      String path = getUrlSuffix(url);
      expect('helloworld.mp3', path);
    });

    /*test('download_test', () async {
      final directory = await Directory.systemTemp.createTemp();
      // Mock out the MethodChannel for the path_provider plugin.
      const MethodChannel('plugins.flutter.io/path_provider')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        // If you're getting the apps documents directory, return the path to the
        // temp directory on the test environment instead.
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return directory.path;
        }
        return null;
      });

      final dir = await getApplicationDocumentsDirectory();
      final player = AudioPlayer();
      await player.dynamicSet(
          url: 'https://www.mboxdrive.com/m54.mp3',
          path: dir.path,
          excludeCallback: (_) => true);

      final player2 = AudioPlayer();
      await player2.cacheFile(url: 'https://www.mboxdrive.com/m54.mp3');

      final player3 = AudioPlayer();
      final url = 'https://www.mboxdrive.com/m54.mp3';
      final existed = await player3.existedInLocal(url: url);
      expect(true, existed);
      if (await player3.existedInLocal(url: url)) {
        expect(player3.getCachedPath(url: url),
            dir.path + '/audio_cache/' + 'm54.mp3');
      }
    });*/

    /*test('download_and_cache_file', () async {
      final player = AudioPlayer();
      player.cacheFile(url: 'https://www.mboxdrive.com/m54.mp3');
    });

    test('playFromFile', () async {
      final player = AudioPlayer();
      final dir = await getApplicationDocumentsDirectory();
      final url = 'https://www.mboxdrive.com/m54.mp3';
      if (await player.existedInLocal(url: url)) {
        expect(player.getCachedPath(url: url),
            dir.path + '/audio_cache/' + 'm54.mp3');
      }
    });*/
  });
}