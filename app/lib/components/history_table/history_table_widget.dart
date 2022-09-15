import 'dart:math';

import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:birdup/components/history_table/history_table_bloc.dart';
import 'package:birdup/model/model.pb.dart';
import 'package:birdup/repo/station.dart';

const double _cellWidth = 40;
const double _cellHeight = 28;
const double _headerHeight = 24;

Color borderColor = Colors.blueGrey[300]!;

TextStyle _textStyle = const TextStyle(
  fontSize: 11.0,
);

class HistoryTableWidget extends StatefulWidget {
  final HistoryTableModel data;

  const HistoryTableWidget({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryTableWidgetState();
}

class _HistoryTableWidgetState extends State<HistoryTableWidget> {
  // Link controllers for fixed headers
  late final LinkedScrollControllerGroup _controllers;
  late final ScrollController _headController;
  late final ScrollController _bodyController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.data.locations.length * widget.data.fields * _cellHeight,
        child: Column(
          children: [
            _Head(
              times: widget.data.times,
              controller: _headController,
            ),
            Expanded(
              child: _Body(
                data: widget.data,
                controller: _bodyController,
              ),
            ),
          ],
        ),
      );
}

class _Cell extends StatelessWidget {
  final Color color;
  final Widget child;
  final double height;
  final double width;
  final bool isLast;
  final bool isHeader;

  final BorderSide _boarder = BorderSide(
    color: borderColor,
    width: 1.0,
  );

  final BorderSide _sideBoarder = BorderSide(
    color: Colors.blueGrey[100]!,
    width: 1.0,
  );

  _Cell({
    required this.child,
    required this.color,
    this.height = _cellHeight,
    this.width = _cellWidth,
    this.isLast = false,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    Border border = (isLast)
        ? Border(
            bottom: _boarder,
            right: (isHeader) ? _boarder : _sideBoarder,
          )
        : Border(
            right: (isHeader) ? _boarder : _sideBoarder,
          );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: border,
        color: color,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _Head extends StatelessWidget {
  final List<DateTime> times;
  final ScrollController controller;

  const _Head({
    required this.times,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _headerHeight,
      child: Row(
        children: [
          Container(
            height: _headerHeight,
            width: _cellWidth * 2,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: borderColor),
                bottom: BorderSide(color: borderColor),
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              '4h',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11.0,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              controller: controller,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: times
                  .map(
                    (time) => _Cell(
                      height: _headerHeight,
                      color: Colors.blueGrey[100]!,
                      isLast: true,
                      isHeader: true,
                      child: Text(
                        "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final HistoryTableModel data;
  final ScrollController controller;

  const _Body({
    required this.data,
    required this.controller,
  });

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

  late final int _fields = widget.data.fields;
  late final List<Location> _locations = widget.data.locations;
  late final int _count = widget.data.times.length;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: _cellWidth * 2,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: borderColor),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            controller: _firstColumnController,
            physics: const ClampingScrollPhysics(),
            children: widget.data.locations
                .map(
                  (l) => _LocationTitle(name: l.name),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            controller: widget.controller,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: _count * _cellWidth,
              child: ListView(
                padding: EdgeInsets.zero,
                controller: _restColumnsController,
                physics: const ClampingScrollPhysics(),
                children: List.generate(_locations.length * _fields, (row) {
                  int location = row ~/ _fields;
                  int ordinal = row % _fields;
                  History history = widget.data.history[location];
                  _CellFactory factory = _cellFactory(ordinal);
                  List<double> data = history.field(row % _fields);
                  return Row(
                    children: List.generate(_count, (column) {
                      return _Cell(
                        color: (ordinal.isOdd)
                            ? Colors.blueGrey[50]!
                            : Colors.white,
                        isLast: ordinal + 1 == _fields,
                        child: factory(data[column]),
                      );
                    }),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Map field ordinal to some widget builder
  // This seems like some existing provider pattern that I'm forgetting..
  _CellFactory _cellFactory(int ordinal) {
    switch (ordinal) {
      case 0:
        // windDirection
        return (v) => Transform.rotate(
              angle: (v + pi),
              child: const Icon(
                Icons.arrow_upward_sharp,
                color: Colors.black,
                size: 16.0,
              ),
            );
      case 1:
        // windAvg
        return (v) => Text(
              (!v.isNaN) ? v.toStringAsFixed(1) : "-",
              textAlign: TextAlign.center,
              style: _textStyle,
            );
      case 2:
        // tempAvg
        return (v) => Text(
              (!v.isNaN) ? "${v.toStringAsFixed(0)}°" : "-",
              textAlign: TextAlign.center,
              style: _textStyle,
            );
      case 3:
        // pressure
        return (v) => Text(
              (!v.isNaN) ? v.toStringAsFixed(1) : "-",
              textAlign: TextAlign.center,
              style: _textStyle,
            );
      case 4:
        // humidity
        return (v) => Text(
              (!v.isNaN) ? "${v.toStringAsFixed(0)}﹪" : "-",
              textAlign: TextAlign.center,
              style: _textStyle,
            );
      default:
        throw Exception("no _CellFactory for field $ordinal");
    }
  }
}

typedef _CellFactory = Widget Function(double v);

class _LocationTitle extends StatelessWidget {
  final String name;
  final double _height = 5 * _cellHeight;

  const _LocationTitle({required this.name});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: borderColor),
          ),
        ),
        child: Row(
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                // flip
                height: _cellWidth - 2,
                width: _height - 1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.blueGrey[100]!),
                  ),
                ),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: _height - 1,
              width: _cellWidth,
              child: Column(
                children: const [
                  _HeaderCell(label: '°'),
                  _HeaderCell(label: 'MPH', grey: true),
                  _HeaderCell(label: '°F'),
                  _HeaderCell(label: 'mBar', grey: true),
                  _HeaderCell(label: '%', last: true),
                ],
              ),
            )
          ],
        ),
      );
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final bool grey;
  final bool last;

  const _HeaderCell({
    required this.label,
    this.grey = false,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: _cellWidth,
        height: (!last) ? _cellHeight : _cellHeight - 1,
        decoration:
            BoxDecoration(color: (grey) ? Colors.blueGrey[50]! : Colors.white),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 10.0,
          ),
        ),
      );
}
