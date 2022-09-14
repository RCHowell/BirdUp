// For now just MIN, MAX, AVG, SUM, COUNT

abstract class Accumulator {
  double get value;

  add(double v);

  reset();
}

class MinAccumulator implements Accumulator {
  @override
  double value = double.infinity;

  @override
  add(double v) {
    if (v < value) {
      value = v;
    }
  }

  @override
  reset() {
    value = double.infinity;
  }
}

class MaxAccumulator implements Accumulator {
  @override
  double value = double.negativeInfinity;

  @override
  add(double v) {
    if (v > value) {
      value = v;
    }
  }

  @override
  reset() {
    value = double.negativeInfinity;
  }
}

class AvgAccumulator implements Accumulator {
  double _sum = 0;
  double _count = 0;

  @override
  double get value => (_count == 0) ? double.nan : _sum / _count;

  @override
  add(double v) {
    _sum += v;
    _count += 1;
  }

  @override
  reset() {
    _sum = 0;
    _count = 0;
  }
}

class SumAccumulator implements Accumulator {
  @override
  double value = 0;

  @override
  add(double v) {
    value += v;
  }

  @override
  reset() {
    value = 0;
  }
}

class CountAccumulator implements Accumulator {
  @override
  double value = 0;

  @override
  add(double v) {
    value += 1;
  }

  @override
  reset() {
    value = 0;
  }
}
