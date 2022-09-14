import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:birdup/components/history/history_model.dart';
import 'package:birdup/model/model.pb.dart';
import 'package:birdup/repo/src/station.dart';

part 'history_event.dart';

part 'history_state.dart';

GetIt injector = GetIt.instance;

const List<HistoryScale> historyScales = [];

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  late final Station station;

  final HistoryScale _scale = const HistoryScale(
    label: '4 hour',
    bin: Duration(minutes: 1),
    period: Duration(hours: 4),
  );

  // cache History
  History? _history;

  HistoryBloc() : super(HistoryStateLoading()) {
    station = injector.get<Station>();
    on<HistoryEventLoad>(_handleLoad);
  }

  Future<void> _handleLoad(
    HistoryEventLoad event,
    Emitter<HistoryState> emit,
  ) async {
    _history ??= await _load(event.station);
    var histogram = _history!.histogram(_scale);
    emit(HistoryStateData(histogram, _scale));
  }

  // TODO FIX THIS PATTERN!!!
  Future<History> _load(int location) async {
    History? history;
    // Register handler
    station.on<StationResBackFill>(location, (res) {
      // I really dislike this pattern;
      history = res.history;
    });
    station.emit(StationReqBackFill(location));

    // await receiving the message
    var expiration = DateTime.now().add(const Duration(seconds: 30));
    while (history == null) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (DateTime.now().isAfter(expiration)) {
        emit(HistoryStateError("timed out"));
      }
    }
    return history!;
  }
}

class HistoryScale {
  final String label;
  final Duration bin;
  final Duration period;

  const HistoryScale({
    required this.label,
    required this.bin,
    required this.period,
  });

  @override
  String toString() => "${period.inMinutes}m:${bin.inMinutes}m";
}
