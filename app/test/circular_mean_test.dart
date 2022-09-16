import 'dart:math';

import 'package:birdup/stats/accumulator.dart';
import 'package:flutter_test/flutter_test.dart';

/// If you are reading this, you may notice this is the only test.
/// https://media.giphy.com/media/l4pTsh45Dg7jnDM6Q/giphy.gif
void main() {
  test('circular mean of hours in the day', () {
    final acc = AngleAvgAccumulator();
    for (var i = 0.0; i < 23.0; i++) {
      acc.add(i);
    }
    var radians = acc.value;
    var hour = radians * 24 / (2 * pi) % 24;
    expect(hour, 19.0);
  });
}