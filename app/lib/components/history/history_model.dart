import 'package:birdup/components/history/history_bloc.dart';
import 'package:birdup/model/model.pb.dart';
import 'package:birdup/stats/accumulator.dart';

class HistoryModel {
  final List<DateTime> times;
  final List<double?> maxWindSpeed;
  final List<double?> minWindSpeed;
  final List<double?> avgWindSpeed;
  final List<double?> avgPressure;
  final List<double?> avgWindDirection;
  final List<double?> avgTemperature;

  HistoryModel({
    required this.times,
    required this.maxWindSpeed,
    required this.minWindSpeed,
    required this.avgWindSpeed,
    required this.avgPressure,
    required this.avgWindDirection,
    required this.avgTemperature,
  });
}

extension Histogram on History {

  // Produces a HistoryModel from raw History data
  HistoryModel histogram(HistoryScale scale) {
    List<DateTime> datetimes = List.empty(growable: true);
    List<double?> maxWindSpeeds = List.empty(growable: true);
    List<double?> minWindSpeeds = List.empty(growable: true);
    List<double?> avgWindSpeeds = List.empty(growable: true);
    List<double?> avgPressures = List.empty(growable: true);
    List<double?> avgWindDirections = List.empty(growable: true);
    List<double?> avgTemperatures = List.empty(growable: true);

    var maxWindSpeedAcc = MaxAccumulator();
    var minWindSpeedAcc = MinAccumulator();
    var avgWindSpeedAcc = AvgAccumulator();
    var avgWindDirectionAcc = AvgAccumulator();
    var avgPressureAcc = AvgAccumulator();
    var avgTemperatureAcc = AvgAccumulator();

    int i = 0;
    int n = times.length;

    // determine start index
    int endTime = times.last;
    int startTime = endTime - scale.period.inSeconds;
    while (times[i] < startTime) {
      i++;
    }

    int windowStart = _round(times[i], scale.bin);
    int windowEnd = windowStart + scale.bin.inSeconds;

    while (i < n) {
      int time = times[i];
      if (time >= windowEnd || i == n - 1) {
        // Add window entry
        datetimes.add(DateTime.fromMillisecondsSinceEpoch(time * 1000));

        // Max Wind
        var maxWindSpeed = maxWindSpeedAcc.value;
        if (maxWindSpeed.isNaN) {
          maxWindSpeeds.add(null);
        } else {
          maxWindSpeeds.add(maxWindSpeed);
        }

        // Min Wind
        var minWindSpeed = minWindSpeedAcc.value;
        if (minWindSpeed.isNaN) {
          minWindSpeeds.add(null);
        } else {
          minWindSpeeds.add(minWindSpeed);
        }

        // Avg Wind
        var avgWindSpeed = avgWindSpeedAcc.value;
        if (avgWindSpeed.isNaN) {
          avgWindSpeeds.add(null);
        } else {
          avgWindSpeeds.add(avgWindSpeed);
        }

        // Pressure
        var avgPressure = avgPressureAcc.value;
        if (avgPressure.isNaN) {
          avgPressures.add(null);
        } else {
          avgPressures.add(avgPressure);
        }

        // Wind Direction
        var windDir = avgWindDirectionAcc.value;
        if (windDir.isNaN) {
          avgWindDirections.add(null);
        } else {
          avgWindDirections.add(windDir);
        }

        var avgTemp = avgTemperatureAcc.value;
        if (avgTemp.isNaN) {
          avgTemperatures.add(null);
        } else {
          avgTemperatures.add(avgTemp);
        }
        // Reset
        maxWindSpeedAcc.reset();
        minWindSpeedAcc.reset();
        avgWindSpeedAcc.reset();
        avgWindDirectionAcc.reset();
        avgPressureAcc.reset();
        avgTemperatureAcc.reset();
        windowStart = windowEnd;
        windowEnd += scale.bin.inSeconds;
      }
      // Accumulate
      maxWindSpeedAcc.add(windSpeed[i]);
      minWindSpeedAcc.add(windSpeed[i]);
      avgWindSpeedAcc.add(windSpeed[i]);
      avgWindDirectionAcc.add(windDirection[i]);
      avgPressureAcc.add(pressure[i]);
      avgTemperatureAcc.add(temp[i]);
      i++;
    }

    return HistoryModel(
      times: datetimes,
      maxWindSpeed: maxWindSpeeds,
      minWindSpeed: minWindSpeeds,
      avgWindSpeed: avgWindSpeeds,
      avgPressure: avgPressures,
      avgWindDirection: avgWindDirections,
      avgTemperature: avgTemperatures,
    );
  }
}

// Round down time by Duration in seconds
int _round(int time, Duration duration) => time - time % duration.inSeconds;
