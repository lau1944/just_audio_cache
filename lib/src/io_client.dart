import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:just_audio_cache/src/parser.dart';

class IoClient {
  static Future<String?> download(
      {required String url, required String rootPath}) async {
    try {
      final res = await http.get(
        Uri.parse(url),
      );
      if (res.statusCode == 200) {
        final bytes = res.bodyBytes;
        final key = parseUrl(url);
        final filePath = rootPath + '/$key';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        return filePath;
      } else {
        return null;
      }
    } on IOException catch (e) {
      print('Error occurs while downloading file: $e');
      return null;
    } catch(e) {
      print(e);
      return null;
    }
  }
}
