# just_audio_cache

[![pub package](https://img.shields.io/pub/v/just_audio_cache.svg)](https://pub.dev/packages/just_audio_cache)

Collection of extension function of [just_audio](https://pub.dev/packages/just_audio) package for auto-handle caching audio files

## How to use

<p> The premise is you already have just_audio package in your dependency </p>

Core method `dynamicSet` would auto handle caching, if the target file not in cache, would download it and push in cache.

The next time the same url request call, would call the local file instead of requesting.

`url` is your audio source, a unique key that represents the stored file path,

`pushIfNotExisted` if true, when the file not exists, would download the file and push in cache

`excludeCallback` a callback function where you can specify which file you don't want to be cached
```dart
import 'package:just_audio_cache/just_audio_cache.dart';

void _play() async {
   // dynamic set your audio source
   await _player.dynamicSet(your_url);
   _player.play();
}
```

<p> If you want to check if the target file exist in cache </p>

```dart
_player.existedInLocal(your_url);
```

<p> Manually add file to cache </p>

```dart
_player.cacheFile(your_audio_url);
```

<p> Get Cached file for the following url </p>

```dart
_player.getCachedFile(url: your_url);
```

<p> Clear all the cache from storage </p>

``` dart
_player.clear();
```






