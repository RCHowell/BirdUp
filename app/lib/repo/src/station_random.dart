import 'dart:async';
import 'dart:math';

import 'package:birdup/model/model.pb.dart';
import 'package:birdup/repo/src/station.dart';

class StationRandom extends Station {
  late final Timer _timer;
  final Random _r = Random();
  final List<int> _locations = List.empty(growable: true);

  @override
  void connect() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      for (int location in _locations) {
        handle(StationResData(
          location: location,
          sample: _randomSample(DateTime.now()),
        ));
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
  }

  @override
  void emit(StationReq req) {
    if (req is StationReqListen) {
      _locations.add(req.location);
    } else if (req is StationReqBackFill) {
      _emitBackFill(req.location);
    }
    // black hole other messages
  }

  void _emitBackFill(int location) {
    Future.delayed(const Duration(milliseconds: 500), () {
      handle(StationResBackFill(
        location: location,
        history: _randomHistory(),
      ));
    });
  }

  History _randomHistory() {
    List<int> times = _genTimes(
      start: DateTime.now().subtract(const Duration(hours: 4)),
      end: DateTime.now(),
      offset: const Duration(minutes: 1),
    ).map((t) => t.millisecondsSinceEpoch ~/ 1000).toList();
    int n = times.length;
    print("Generating $n random historical datapoints");
    return History(
      times: times,
      windDirection: _genData(n, 0, 359.9),
      windSpeed: _genData(n, 0, 15),
      temp: _genData(n, 45, 80),
      pressure: _genData(n, 1000, 1200),
      humidity: _genData(n, 80, 100),
    );
  }

  Sample _randomSample(DateTime time) => Sample(
        timestamp: time.millisecondsSinceEpoch ~/ 1000,
        windSpeed: _random(0, 15),
        windDirection: _random(0, 359.9),
        temp: _random(45, 80),
        pressure: _random(1000, 1200),
        humidity: _random(80, 100),
      );

  List<DateTime> _genTimes({
    required DateTime start,
    required DateTime end,
    required Duration offset,
  }) {
    List<DateTime> times = List.empty(growable: true);
    DateTime time = start;
    while (time.isBefore(end)) {
      times.add(time);
      time = time.add(offset);
    }
    return times;
  }

  List<double> _genData(int n, double lower, double upper) =>
      List.generate(n, (_) => _random(lower, upper));

  double _random(double lower, double upper) =>
      lower + (upper - lower) * _r.nextDouble();
}
