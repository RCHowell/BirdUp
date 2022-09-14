import 'package:birdup/model/model.pb.dart';
import 'package:birdup/stats/accumulator.dart';

extension Window on History {
  
  // Produce a new History object where time periods are grouped by the Duration
  History window(Duration duration) {

    // Calculate averages for each time window
    var h = History();
    var temp = AvgAccumulator();
    var windSpeed = AvgAccumulator();
    var windDirection = AvgAccumulator();
    var pressure = AvgAccumulator();
    var humidity = AvgAccumulator();

    int i = 0;
    int n = times.length;

    int windowStart = _round(times[0], duration);
    int windowEnd = windowStart + duration.inSeconds;

    while (i < n) {
      int time = times[i];
      if (time < windowEnd) {
        // Accumulate
        temp.add(this.temp[i]);
        windSpeed.add(this.windSpeed[i]);
        windDirection.add(this.windDirection[i]);
        pressure.add(this.pressure[i]);
        humidity.add(this.humidity[i]);
      } else {
        // Add window entry
        h.times.add(time);
        h.temp.add(temp.value);
        h.windSpeed.add(windSpeed.value);
        h.windDirection.add(windDirection.value);
        h.pressure.add(pressure.value);
        h.humidity.add(humidity.value);
        // Reset
        temp.reset();
        windSpeed.reset();
        windDirection.reset();
        pressure.reset();
        humidity.reset();
        // Adjust window
        windowStart = windowEnd;
        windowEnd += duration.inSeconds;
      }
      i++;
    }
    return h;
  }
}

// Time in seconds
int _round(int time, Duration duration) => time - time % duration.inSeconds;
