

/// Parse url, get a unique string
/// example: www.google/micro/web/video.mp3 -> video.mp3
String getUrlSuffix(String url) {
  StringBuffer _buffer = StringBuffer();
  final urlFormat = Uri.dataFromString(url);
  List<String> paths = urlFormat.path.split('/');
  if (paths.isNotEmpty) {
    for (final p in paths) {
      _buffer.write(p);
    }
    return _buffer.toString();
  }
  return 'default';
}