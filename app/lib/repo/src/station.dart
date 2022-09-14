import 'package:flutter/foundation.dart';
import 'package:birdup/model/model.pb.dart';

// Basic interface for a realtime weather station
abstract class Station {
  // Eventually clean up handlers that are out-of-scope
  final List<_Handler> _handlers = List.empty(growable: true);

  // Initiate
  void connect();

  // Cleanup
  void dispose();

  // Request
  void emit(StationReq req);

  // Listen
  void on<E extends StationRes>(int location, Callback<E> callback) {
    _handlers.add(_Handler(
      type: E,
      location: location,
      callback: callback,
    ));
  }

  void handle(StationRes res) {
    _handlers
        .where((h) =>
            h.location == res.location && h.type == res.runtimeType)
        .forEach((h) => h.callback(res));
  }
}

typedef Callback<E extends StationRes> = void Function(E res);

class _Handler<E extends StationRes> {
  final Type type;
  final int location;
  final Function callback;

  _Handler({
    required this.type,
    required this.location,
    required this.callback,
  });
}

abstract class StationReq {
  // websocket wire format
  String get message;
}

abstract class StationRes {
  int get location;
}

class StationReqBackFill extends StationReq {
  final int location;

  @override
  String get message => "bkwx:$location:4hour";

  StationReqBackFill(this.location);
}

class StationReqListen extends StationReq {
  final int location;

  @override
  String get message => "stwx:$location";

  StationReqListen(this.location);
}

class StationResData extends StationRes {
  @override
  final int location;
  final Sample sample;

  StationResData({
    required this.sample,
    required this.location,
  });
}

class StationResBackFill extends StationRes {
  @override
  final int location;
  final History history;

  StationResBackFill({
    required this.location,
    required this.history,
  });
}

extension FieldOrdinals on History {
  List<double> field(int ordinal) {
    switch (ordinal) {
      case 0:
        return windDirection;
      case 1:
        return windSpeed;
      case 2:
        return temp;
      case 3:
        return pressure;
      case 4:
        return humidity;
      default:
        // throw?
        return List.empty();
    }
  }
}
