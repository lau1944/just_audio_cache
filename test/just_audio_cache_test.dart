import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('audio_test', () {
    test('download_test', () async {
      final spMockCacheStrs = <String, String>{};
      final directory = await Directory.systemTemp.createTemp();
      // Mock out the MethodChannel for the path_provider plugin.
      const MethodChannel('plugins.flutter.io/path_provider')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        // If you're getting the apps documents directory, return the path to the
        // temp directory on the test environment instead.
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return directory.path;
        }
        if (methodCall.method == 'getTemporaryDirectory') {
          return directory.path;
        }
        return null;
      });
      // Mock out the MethodChannel for the share_preference plugin.
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        // If you're getting the apps documents directory, return the path to the
        // temp directory on the test environment instead.
        if (methodCall.method == 'getAll') {
          return spMockCacheStrs;
        }
        if (methodCall.method == 'setString') {
          spMockCacheStrs[methodCall.arguments] = methodCall.arguments;
          return true;
        }
        if (methodCall.method == 'getString') {
          return spMockCacheStrs[methodCall.arguments];
        }
      });

      final dir = await getApplicationDocumentsDirectory();
      final player = AudioPlayer();
      final sources = [
        'https://www.mboxdrive.com/m54.mp3',
        'https://www.mboxdrive.com/%c3%86STRAL%20-%20half%20light.mp3',
        'https://www.mboxdrive.com/%ca%8f%e1%b4%80%20%ca%99%e1%b4%9c%e1%b4%85%e1%b4%9c.mp3'
      ];
      await player.dynamicSetAll(sources);
      // await player.dynamicSet(
      //     url: 'https://www.mboxdrive.com/m54.mp3',
      //     path: dir.path,
      //     excludeCallback: (_) => true);
      for (final url in sources) {
        expect(await player.existedInLocal(url: url), true);
      }

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
  });
}
