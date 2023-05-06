import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:birdup/model/model.pb.dart';
import 'package:birdup/repo/src/station.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StationDrw extends Station {
  late WebSocketChannel _ws;

  // Keep track of back fill locations
  final Queue<int> _locations = Queue();

  // Cache history
  final Map<int, History> _historyCache = {};

  @override
  void connect() {
    try {
      _ws = WebSocketChannel.connect(
        Uri.parse('wss://drw.selfip.com/wxstn/ws'),
      );
      _ws.stream.listen(_handle);
    } catch (ex) {
      throw Exception("unable to connect: $ex");
    }
  }

  @override
  void dispose() {
    _ws.sink.close();
  }

  @override
  void emit(StationReq req) {
    if (req is StationReqBackFill) {
      if (_historyCache.containsKey(req.location)) {
        handle(StationResBackFill(
          location: req.location,
          history: _historyCache[req.location]!,
        ));
        return;
      }
      // back fill requests must be serialized since they don't contain
      // station ids
      _locations.add(req.location);
    }
    print("emitting message ${req.message}");
    _ws.sink.add(req.message);
  }

  void _handle(dynamic message) {
    StationRes? res = _decode(message);
    if (res != null) {
      handle(res);
    }
  }

  StationRes? _decode(dynamic message) {
    if (message is Uint8List) {
      if (_locations.isEmpty) {
        // blob is not associated with a location identifier, skip
        return null;
      }
      int location = _locations.removeFirst();
      Uint32List buffer = message.buffer.asUint32List();
      History history = _parseBackFill(buffer);
      _historyCache[location] = history;
      return StationResBackFill(
        location: location,
        history: history,
      );
    } else if (message is String) {
      if (message.startsWith("data")) {
        Sample sample = _parseData(message.substring("data:".length));
        return StationResData(
          location: sample.location,
          sample: sample,
        );
      }
    }
    return null;
  }

  Sample _parseData(String message) {
    Map<String, dynamic> map = jsonDecode(message);
    return Sample(
      location: map['id'],
      // timestamp: map['ts'] ~/ 1000,
      windDirection: (map['direction'] as num).toDouble(),
      //windSpeed: 0.621371 * (map['windspeed'] as num).toDouble(),
      windSpeed: (map['windspeed'] as num).toDouble(),
      // MPH
      temp: ((map['temperature'] ?? 0) as num).toDouble() * (9 / 5) + 32,
      pressure: ((map['pressure'] ?? 0) as num).toDouble(),
      humidity: ((map['humidity'] ?? 0) as num).toDouble(),
    );
  }

  History _parseBackFill(Uint32List buffer) {
    History h = History();
    Float32List bytes = buffer.buffer.asFloat32List();
    int i = 0;
    // Order in `bytes` matters!
    while (i < bytes.length) {
      var time = buffer[i++];
      var temp = bytes[i++];
      var tempMax = bytes[i++]; // ignore
      var tempMin = bytes[i++]; // ignore
      var pressure = bytes[i++];
      var humidity = bytes[i++];
      var windSpeed = bytes[i++];
      var windSpeedMax = bytes[i++]; // ignore
      var windDirection = bytes[i++];
      var voltage = bytes[i++]; // ignore
      var voltageMax = bytes[i++]; // ignore
      var voltageMin = bytes[i++]; // ignore
      var a = bytes[i++]; // ignore
      var aMax = bytes[i++]; // ignore
      var r = bytes[i++]; // ignore
      var ex = bytes[i++]; // ignore
      var ed = bytes[i++]; // ignore
      var er = bytes[i++]; // ignore
      if (_isValid(
        temp: temp,
        pressure: pressure,
        humidity: humidity,
        windSpeed: windSpeed,
        windDirection: windDirection,
      )) {
        h.times.add(time);
        h.temp.add(temp * (9 / 5) + 32);
        h.pressure.add(pressure);
        h.humidity.add(humidity);
        h.windSpeed.add(windSpeed);
        h.windDirection.add(windDirection);
      }
    }
    return h;
  }

  bool _isValid({
    required double temp,
    required double pressure,
    required double humidity,
    required double windSpeed,
    required double windDirection,
  }) {
    if (temp.isNaN || temp < -50 || temp > 50) {
      return false;
    }
    if (pressure.isNaN || pressure < -850 || pressure > 1100) {
      return false;
    }
    if (humidity.isNaN || humidity < 1e-6 || humidity > 100) {
      return false;
    }
    if (windSpeed.isNaN || windSpeed < 0 || windSpeed > 100) {
      return false;
    }
    if (windDirection.isNaN || windDirection < 0 || windDirection > 360) {
      return false;
    }
    return true;
  }
}
