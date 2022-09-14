import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:birdup/model/model.pb.dart';
import 'package:birdup/repo/station.dart';
import 'package:birdup/stats/window.dart';

part 'history_table_event.dart';
part 'history_table_state.dart';
part 'history_table_model.dart';

GetIt injector = GetIt.instance;
Duration waitTime = const Duration(milliseconds: 50);

class HistoryTableBloc extends Bloc<HistoryTableEvent, HistoryTableState> {
  late final Station station;

  HistoryTableBloc() : super(HistoryTableStateLoading()) {
    station = injector.get<Station>();
    on<HistoryTableEventLoad>(_handleLoad);
  }

  Future<void> _handleLoad(
    HistoryTableEventLoad event,
    Emitter<HistoryTableState> emit,
  ) async {
    try {
      List<StationResBackFill> backfill = List.empty(growable: true);

      // Load all. This is bad code.
      for (var location in event.locations) {
        StationResBackFill? data;
        station.on<StationResBackFill>(location.id, (res) {
          data = res;
        });
        station.emit(StationReqBackFill(location.id));

        DateTime expiration = DateTime.now().add(const Duration(seconds: 30));
        while (data == null) {
          await Future.delayed(waitTime);
          if (DateTime.now().isAfter(expiration)) {
            throw Exception("timed out");
          }
        }
        backfill.add(data!);
      }

      // Expensive? Calculate windowed averages
      print("Starting with ${backfill.first.history.times.length} historical datapoints");
      List<History> history = backfill
          .map((b) => b.history.window(const Duration(minutes: 15)))
          .toList();
      print("Reduced to ${history.first.times.length} windows");

      // Pull out times for easy rendering
      List<DateTime> times = history.first
          .times
          .map((t) => DateTime.fromMillisecondsSinceEpoch(t * 1000))
          .toList();

      // Send update
      emit(HistoryTableStateData(data: HistoryTableModel(
        locations: event.locations,
        times:  times,
        history: history,
      )));
    } catch (e) {
      // TODO show error message in some capacity
      print(e);
      emit(HistoryTableStateEmpty());
    }
  }
}
