import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

// Pre-filter data so we don't blow up if one image load fails
class NullableStationImage {
  final int? timestamp;
  final Uint8List? image;

  NullableStationImage({
    required this.timestamp,
    required this.image,
  });
}

// Post-filter data so we don't have to deal with nulls
class StationImage {
  final int timestamp;
  final Uint8List image;

  StationImage({
    required this.timestamp,
    required this.image,
  });
}

class StationCam {
  final String _base = 'https://drw.selfip.com';
  final String _url = 'https://drw.selfip.com/looper.php';
  final Dio _dio = Dio();
  final RegExp _regex = RegExp(r'images\/.*.jpg');
  final Options _options = Options(responseType: ResponseType.bytes);

  // Example: images/20220830162817.jpg
  final DateFormat _format = DateFormat("Ymd");

  // Loads all images from the 10-min window
  Future<List<NullableStationImage>> load() async {
    Response response = await _dio.get(_url);
    String body = response.data.toString();
    Iterable<Future<NullableStationImage>> futures =
        _regex.allMatches(body).map((m) => m[0]!).map((url) async {
      Uint8List? image;
      try {
        var res = await _dio.get("$_base/$url", options: _options);
        image = res.data as Uint8List;
      } on DioError catch (e) {
        if (e.type == DioErrorType.response) {
          // 404 — eat this and return missing
          image = null;
        } else {
          rethrow;
        }
      }
      return NullableStationImage(
        timestamp: _parse(url),
        image: image,
      );
    });
    return Future.wait(futures);
  }

  // Parse DateTime integer from 'images/20220830162817.jpg'
  // I couldn't get DateFormat working
  int? _parse(String v) {
    try {
      if (v.length != 'images/YYYYMMDDHHmmSS.jpg'.length) {
        return null;
      }
      var t = v.substring('images/'.length, v.length - '.jpg'.length);
      return int.parse(t);
    } catch (e) {
      return null;
    }
  }
}
