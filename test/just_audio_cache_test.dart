import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('audio_test', () {
    test('download_test', () async {
      final player = AudioPlayer();
      player.setUrl('test_url');
      await player.playFromDynamic();

      final dir = await getApplicationDocumentsDirectory();
      final file = File(dir.path + '/' + 'audio_cache' + '/' + 'test_url');
      expect(true, file.existsSync());
    });
  });
}
