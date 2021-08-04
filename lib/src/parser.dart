
/// Parse url, get the last path of a url
/// example: www.google/micro/web/video.mp3 -> video.mp3
String parseUrl(String url) {
  List<String> paths = url.split('/');
  if (paths.isNotEmpty) {
    return paths[paths.length - 1];
  }
  return 'default';
}