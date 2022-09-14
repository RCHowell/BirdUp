import 'package:flutter/material.dart';

class ChartPageTheme {
  final AppBarTheme appbar;
  final ChartTheme chartTheme;

  ChartPageTheme(this.appbar, this.chartTheme);
}

class ChartTheme {
  final Color background;
  final TooltipTheme tooltip;
  final Map<String, Color> series;

  ChartTheme._({
    required this.background,
    required this.tooltip,
    required this.series,
  });

  static ChartTheme light = ChartTheme._(
    background: Colors.white,
    tooltip: TooltipTheme.light,
    series: {
      // 'avg': const Color.fromARGB(255, 51, 101, 138),
      'avg': Colors.blueGrey[600]!,
      'pressure': Colors.blueGrey[600]!,
      'dir': Colors.blueGrey[600]!,
      'temp': Colors.blueGrey[600]!,
    },
  );
}

class TooltipTheme {
  final Color color;
  final Color border;
  final TextStyle textStyle;

  TooltipTheme._({
    required this.color,
    required this.border,
    required this.textStyle,
  });

  static TooltipTheme light = TooltipTheme._(
    color: Colors.grey[50]!,
    border: Colors.blueGrey[300]!,
    textStyle: const TextStyle(
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w200,
      fontSize: 10,
      color: Colors.black,
    ),
  );
}
