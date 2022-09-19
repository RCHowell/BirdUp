import 'dart:math';

import 'package:birdup/stats/accumulator.dart';
import 'package:flutter_test/flutter_test.dart';

/// If you are reading this, you may notice this is the only test.
/// https://media.giphy.com/media/l4pTsh45Dg7jnDM6Q/giphy.gif
void main() {

  test("circular mean", () {
    final acc = AngleAvgAccumulator();
    final values = [
      2.61,
      2.07,
      1.91,
    ];
    values.forEach((element) {
      var degrees = element * (180 / pi);
      acc.add(degrees);
    });
    print(acc.value);
  });
}
