import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:birdup/components/history/history_bloc.dart';
import 'package:birdup/components/history/history_model.dart';
import 'package:birdup/theme/chart_theme.dart';

final _windSpeedChartKey = GlobalKey<_WindSpeedChartState>();
final _windDirectionChartKey = GlobalKey<_WindDirectionChartState>();
final _temperatureChartKey = GlobalKey<_TemperatureChartState>();
final _pressureChartKey = GlobalKey<_PressureChartState>();

double _zoomPan = 0.0;
double _zoomFactor = 1.0;

class HistoryCharts extends StatelessWidget {
  final int station;
  final HistoryStateData state;
  final ChartTheme theme = ChartTheme.light;

  HistoryCharts({
    required this.station,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 16.0),
                const _Title('Wind Speed (mph)'),
                SizedBox(
                  height: 180,
                  child: _WindSpeedChart(
                    key: _windSpeedChartKey,
                    data: state.history,
                    theme: theme,
                  ),
                ),
                const Divider(),
                const _Title('Wind Direction'),
                SizedBox(
                  height: 180,
                  child: _WindDirectionChart(
                    key: _windDirectionChartKey,
                    data: state.history,
                    theme: theme,
                  ),
                ),
                const Divider(),
                const _Title('Temperature (F)'),
                SizedBox(
                  height: 180,
                  child: _TemperatureChart(
                    key: _temperatureChartKey,
                    data: state.history,
                    theme: theme,
                  ),
                ),
                const Divider(),
                const _Title('Pressure (mBar)'),
                SizedBox(
                  height: 180,
                  child: _PressureChart(
                    key: _pressureChartKey,
                    data: state.history,
                    theme: theme,
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      );
}

class _Title extends StatelessWidget {
  final String title;

  const _Title(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}

// ====================
//  Wind (min/max/avg)
// ====================

class _WindSpeedChart extends StatefulWidget {
  final ChartTheme theme;
  final HistoryModel data;

  const _WindSpeedChart({
    required this.theme,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _WindSpeedChartState();
}

class _WindSpeedChartState extends State<_WindSpeedChart> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;

  // trigger rebuild
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
    );
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        color: widget.theme.tooltip.color,
        arrowLength: 0.0,
        borderWidth: 1.0,
        borderColor: widget.theme.tooltip.border,
        textStyle: widget.theme.tooltip.textStyle,
        decimalPlaces: 1,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SfCartesianChart(
        zoomPanBehavior: _zoomPanBehavior,
        trackballBehavior: _trackballBehavior,
        primaryXAxis: DateTimeAxis(
          zoomFactor: _zoomFactor,
          zoomPosition: _zoomPan,
          name: 'x::axis',
        ),
        primaryYAxis: NumericAxis(
          minimum: 0.0,
          maximum: 20.0,
          interval: 5.0,
        ),
        onZooming: (ZoomPanArgs args) {
          if (args.axis?.name == 'x::axis') {
            _zoomPan = args.currentZoomPosition;
            _zoomFactor = args.currentZoomFactor;
            // sync other charts
            _pressureChartKey.currentState!.refresh();
            _temperatureChartKey.currentState!.refresh();
            _windDirectionChartKey.currentState!.refresh();
          }
        },
        series: <ChartSeries>[
          RangeAreaSeries<double?, DateTime>(
            dataSource: widget.data.maxWindSpeed,
            xValueMapper: (_, i) => widget.data.times[i],
            lowValueMapper: (_, i) => widget.data.minWindSpeed[i],
            highValueMapper: (_, i) => widget.data.maxWindSpeed[i],
            color: Colors.blueGrey[50],
            borderDrawMode: RangeAreaBorderMode.excludeSides,
            borderColor: Colors.blueGrey[300],
            borderWidth: 1,
          ),
          FastLineSeries<double?, DateTime>(
            name: 'avg',
            legendIconType: LegendIconType.circle,
            dataSource: widget.data.avgWindSpeed,
            xValueMapper: (_, i) => widget.data.times[i],
            yValueMapper: (v, _) => v,
            color: widget.theme.series['avg'],
            animationDelay: 0.0,
            animationDuration: 500,
          )
        ],
      );
}

// ==================
//  Pressure
// ==================

class _PressureChart extends StatefulWidget {
  final ChartTheme theme;
  final HistoryModel data;

  const _PressureChart({
    required this.theme,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _PressureChartState();
}

class _PressureChartState extends State<_PressureChart> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;

  // trigger rebuild
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
    );
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        color: widget.theme.tooltip.color,
        arrowLength: 0.0,
        borderWidth: 1.0,
        borderColor: widget.theme.tooltip.border,
        textStyle: widget.theme.tooltip.textStyle,
        decimalPlaces: 1,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 120.0,
        child: SfCartesianChart(
          zoomPanBehavior: _zoomPanBehavior,
          trackballBehavior: _trackballBehavior,
          primaryXAxis: DateTimeAxis(
            zoomFactor: _zoomFactor,
            zoomPosition: _zoomPan,
            name: 'x::axis',
          ),
          primaryYAxis: NumericAxis(
            interval: 0.2,
            numberFormat: NumberFormat("###.0#"),
            decimalPlaces: 1,
          ),
          onZooming: (ZoomPanArgs args) {
            if (args.axis?.name == 'x::axis') {
              _zoomPan = args.currentZoomPosition;
              _zoomFactor = args.currentZoomFactor;
              // sync other charts
              _windSpeedChartKey.currentState!.refresh();
              _temperatureChartKey.currentState!.refresh();
              _windDirectionChartKey.currentState!.refresh();
            }
          },
          series: <ChartSeries>[
            FastLineSeries<double?, DateTime>(
              name: 'pressure',
              legendIconType: LegendIconType.circle,
              dataSource: widget.data.avgPressure,
              xValueMapper: (_, i) => widget.data.times[i],
              yValueMapper: (v, _) => v,
              color: widget.theme.series['pressure'],
              animationDelay: 0.0,
              animationDuration: 500,
            ),
          ],
        ),
      );
}

// ==================
//  Wind Direction
// ==================

class _WindDirectionChart extends StatefulWidget {
  final ChartTheme theme;
  final HistoryModel data;

  const _WindDirectionChart({
    required this.theme,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _WindDirectionChartState();
}

class _WindDirectionChartState extends State<_WindDirectionChart> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;

  // trigger rebuild
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
    );
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        color: widget.theme.tooltip.color,
        arrowLength: 0.0,
        borderWidth: 1.0,
        borderColor: widget.theme.tooltip.border,
        textStyle: widget.theme.tooltip.textStyle,
        decimalPlaces: 1,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 120.0,
    child: SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      trackballBehavior: _trackballBehavior,
      primaryXAxis: DateTimeAxis(
        zoomFactor: _zoomFactor,
        zoomPosition: _zoomPan,
        name: 'x::axis',
      ),
      primaryYAxis: NumericAxis(
        maximum: 360.0,
        minimum: 0.0,
        interval: 90.0,
      ),
      onZooming: (ZoomPanArgs args) {
        if (args.axis?.name == 'x::axis') {
          _zoomPan = args.currentZoomPosition;
          _zoomFactor = args.currentZoomFactor;
          // sync other charts
          _windSpeedChartKey.currentState!.refresh();
          _temperatureChartKey.currentState!.refresh();
          _pressureChartKey.currentState!.refresh();
        }
      },
      series: <ChartSeries>[
        ScatterSeries<double?, DateTime>(
          name: 'dir',
          legendIconType: LegendIconType.circle,
          dataSource: widget.data.avgWindDirection,
          xValueMapper: (_, i) => widget.data.times[i],
          yValueMapper: (v, _) => v,
          color: widget.theme.series['dir'],
          animationDelay: 0.0,
          animationDuration: 500,
          markerSettings: const MarkerSettings(
            height: 4.0,
            width: 4.0,
          ),
        ),
      ],
    ),
  );
}

// ==================
//  Temperature
// ==================

class _TemperatureChart extends StatefulWidget {
  final ChartTheme theme;
  final HistoryModel data;

  const _TemperatureChart({
    required this.theme,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<_TemperatureChart> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;

  // trigger rebuild
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
    );
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        color: widget.theme.tooltip.color,
        arrowLength: 0.0,
        borderWidth: 1.0,
        borderColor: widget.theme.tooltip.border,
        textStyle: widget.theme.tooltip.textStyle,
        decimalPlaces: 1,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 120.0,
    child: SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      trackballBehavior: _trackballBehavior,
      primaryXAxis: DateTimeAxis(
        zoomFactor: _zoomFactor,
        zoomPosition: _zoomPan,
        name: 'x::axis',
      ),
      primaryYAxis: NumericAxis(
        minimum: 0.0,
        interval: 10.0,
      ),
      onZooming: (ZoomPanArgs args) {
        if (args.axis?.name == 'x::axis') {
          _zoomPan = args.currentZoomPosition;
          _zoomFactor = args.currentZoomFactor;
          // sync other charts
          _windSpeedChartKey.currentState!.refresh();
          _pressureChartKey.currentState!.refresh();
          _windDirectionChartKey.currentState!.refresh();
        }
      },
      series: <ChartSeries>[
        FastLineSeries<double?, DateTime>(
          name: 'dir',
          legendIconType: LegendIconType.circle,
          dataSource: widget.data.avgTemperature,
          xValueMapper: (_, i) => widget.data.times[i],
          yValueMapper: (v, _) => v,
          color: widget.theme.series['temp'],
          animationDelay: 0.0,
          animationDuration: 500,
        ),
      ],
    ),
  );
}
