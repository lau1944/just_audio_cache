import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/src/io_client.dart';
import 'package:just_audio_cache/src/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension AudioPlayerExtension on AudioPlayer {
  static SharedPreferences? _sp;

  /// Check if the file corresponds the url exists in local
  Future<bool> existedInLocal({required String url}) async {
    if (_sp == null) _sp = await SharedPreferences.getInstance();

    return _sp!.getString(getUrlSuffix(url)) != null;
  }

  /// Get audio file cache path
  Future<String?> getCachedPath({required String url}) async {
    if (_sp == null) _sp = await SharedPreferences.getInstance();

    return _sp!.getString(getUrlSuffix(url));
  }

  /// Get audio from local if exist, otherwise download from network
  /// [url] is your audio source, a unique key that represents the stored file path,
  /// [path] the storage path you want to save your cache
  /// [pushIfNotExisted] if true, when the file not exists, would download the file and push in cache
  /// [excludeCallback] a callback function where you can specify which file you don't want to be cached
  Future<Duration?> dynamicSet({
    required String url,
    String? path,
    bool pushIfNotExisted = true,
    bool excludeCallback(url)?,
    bool preload = true,
  }) async {
    if (_sp == null) _sp = await SharedPreferences.getInstance();

    if (excludeCallback != null) {
      pushIfNotExisted = excludeCallback(url);
    }

    final dirPath = path ?? (await _openDir()).path;

    final key = getUrlSuffix(url);
    // File check
    if (await _isKeyExisted(key)) {
      // existed, play from local file
      try {
        return await setFilePath(_sp!.getString(key)!, preload: preload);
      } catch (e) {
        print(e);
      }
    }

    final duration = await setUrl(url, preload: preload);

    // download to cache after setUrl in order to show the audio buffer state
    if (pushIfNotExisted) {
      final storedPath =
          await IoClient.download(url: url, path: dirPath + '/' + key);
      if (storedPath != null) {
        _sp!.setString(key, storedPath);
      }
    }

    return duration;
  }

  Future<void> cacheFile({required String url, String? path}) async {
    final dirPath = path ?? (await _openDir()).path;
    final key = getUrlSuffix(url);
    final storedPath = await IoClient.download(url: url, path: dirPath);
    if (storedPath != null) {
      _sp!.setString(key, storedPath);
    }
  }

  /// Clear all the cache in the app dir
  Future<void> clearCache({String? path}) async {
    final dir = path != null ? Directory(path) : (await _openDir());
    return dir.deleteSync();
  }

  Future<void> playFromFile({required String filePath}) async {
    await setFilePath(filePath);
    return await play();
  }

  Future<bool> _isKeyExisted(String key) async {
    if (_sp == null) _sp = await SharedPreferences.getInstance();

    return _sp!.getString(key) != null;
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
