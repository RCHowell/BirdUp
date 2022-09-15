import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:birdup/components/compass/compass_bloc.dart';
import 'package:birdup/model/model.pb.dart';
import 'package:birdup/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class Compass extends StatelessWidget {
  final Location location;

  const Compass({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<CompassBloc>(
        create: (context) =>
            CompassBloc()..add(CompassEventListen(location.id)),
        child: InkWell(
          onTap: () {
            // no historical data for South launch
            if (location.id == 199866) {
              _launchUrl();
            } else {
              context.router.push(ChartRoute(
                name: location.name,
                station: location.id,
              ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<CompassBloc, CompassState>(
                    builder: (context, state) {
                      if (state is CompassStateData) {
                        return _Compass(state.sample);
                      } else {
                        throw Exception("unhandled state $state");
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    location.name,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Compass extends StatelessWidget {
  final Sample? sample;

  const _Compass(this.sample);

  @override
  Widget build(BuildContext context) => Center(
        child: Stack(
          children: [
            CustomPaint(
              foregroundPainter: CompassPainter(
                windSpeed: sample?.windSpeed ?? 0.0,
                radians: (sample?.windDirection ?? 0.0) * pi / 180,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sample?.windSpeed.toStringAsFixed(0) ?? "-",
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "MPH",
                      style: TextStyle(
                        fontSize: 8.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class CompassPainter extends CustomPainter {
  final double radians;
  final double windSpeed;

  CompassPainter({
    required this.radians,
    required this.windSpeed,
  }) : super();

  List<double> angles = [0, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75];

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blueGrey[500]!
      ..strokeWidth = 1.0;

    Paint tick = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blueGrey[800]!
      ..strokeWidth = 1.0;

    Paint needle = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red[400]!
      ..strokeWidth = 2.0;

    double radius = min(size.width / 2.0, size.height / 2.0);
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset start = Offset(center.dx, center.dy - radius);
    Offset end = Offset(center.dx, center.dy - 28);

    canvas.translate(center.dx, center.dy);
    canvas.rotate(radians);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawCircle(center, radius, circle);

    // draw ticks
    for (double a in angles) {
      double ang = a * pi - radians;
      Offset start =
          Offset(center.dx + 28 * cos(ang), center.dy + 28 * sin(ang));
      Offset end =
          Offset(center.dx + radius * cos(ang), center.dy + radius * sin(ang));
      canvas.drawLine(start, end, tick);
    }

    if (windSpeed >= 1) {
      canvas.drawLine(start, end, needle);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// For South Launch historical data
Future<void> _launchUrl() async {
  var url =
      Uri.parse("https://tempestwx.com/station/71752/graph/199866/wind/2");
  if (!await launchUrl(url)) {
    throw 'Could not open $url';
  }
}
