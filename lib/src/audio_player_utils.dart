import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/src/io_client.dart';
import 'package:just_audio_cache/src/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension AudioPlayerExtension on AudioPlayer {
  static SharedPreferences? _sp;

  /// Check if the file corresponds the key exists in local
  Future<bool> existedInLocal({required String key}) async {
    if (_sp == null) _sp = await SharedPreferences.getInstance();

    return _sp!.getString(key) != null;
  }

  /// Play audio from local if exist, otherwise play from network
  /// [url] is your audio source, a unique key that represents the stored file path,
  /// [pushIfNotExisted] if true, when the file not exists, would download the file and push in cache
  /// [excludeCallback] a callback function where you can specify which file you don't want to be cached
  Future<void> playFromDynamic(
      {bool pushIfNotExisted = true, bool excludeCallback(url)?}) async {
    String url = '';
    if (audioSource is UriAudioSource) {
      url = (audioSource as UriAudioSource).uri.toString();
    } else {
      throw ArgumentError('Please call setUrl before any play operation');
    }
    if (_sp == null) _sp = await SharedPreferences.getInstance();

    if (excludeCallback != null) {
      pushIfNotExisted = excludeCallback(url);
    }

    final dirPath = (await _openDir()).path;

    final key = parseUrl(url);
    // File check
    if (await existedInLocal(key: key)) {
      // existed, play from local file
      return await playFromFile(filePath: _sp!.getString(key)!);
    }

    await play();

    if (pushIfNotExisted) {
      final storedPath = await IoClient.download(url: url, rootPath: dirPath);
      if (storedPath != null) {
        _sp!.setString(key, storedPath);
      }
    }
  }

  Future<void> cacheFile({required String url}) async {
    final dirPath = (await _openDir()).path;
    final key = parseUrl(url);
    final storedPath = await IoClient.download(url: url, rootPath: dirPath);
    if (storedPath != null) {
      _sp!.setString(key, storedPath);
    }
  }

  /// Clear all the cache in the app dir
  Future<void> clearCache() async {
    final dir = await _openDir();
    return dir.deleteSync();
  }

  Future<void> playFromFile({required String filePath}) async {
    await setFilePath(filePath);
    return await play();
  }

  Future<Directory> _openDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final Directory targetDir = Directory(dir.path + '/audio_cache');
    if (!targetDir.existsSync()) {
      targetDir.createSync();
    }
    return targetDir;
  }
}
