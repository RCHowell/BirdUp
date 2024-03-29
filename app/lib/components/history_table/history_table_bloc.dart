import 'dart:async';
import 'dart:math';

import 'package:birdup/components/history/history_bloc.dart';
import 'package:birdup/components/history/history_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:birdup/model/model.pb.dart';
import 'package:birdup/repo/station.dart';

part 'history_table_event.dart';

part 'history_table_state.dart';

part 'history_table_model.dart';

GetIt injector = GetIt.instance;
Duration waitTime = const Duration(milliseconds: 50);

HistoryScale _scale = const HistoryScale(
  label: "4h x 15m",
  bin: Duration(minutes: 15),
  period: Duration(hours: 4),
);

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

      List<Location> locations = List.empty(growable: true);
      List<StationResBackFill> backfill = List.empty(growable: true);

      // Load all. This is bad code. Needs to be serialized though.
      for (var location in event.locations) {

        // Callback
        StationResBackFill? data;
        station.on<StationResBackFill>(location.id, (res) {
          data = res;
        });
        station.emit(StationReqBackFill(location.id));

        // try to get the current station in 15 seconds
        DateTime expiration = DateTime.now().add(const Duration(seconds: 15));
        while (data == null) {
          await Future.delayed(waitTime);
          if (DateTime.now().isAfter(expiration)) {
            break;
          }
        }

        // Add to list
        if (data != null && (data?.history.times.isNotEmpty == true)) {
          locations.add(location);
          backfill.add(data!);
        }
      }

      if (backfill.isEmpty) {
        throw Exception("timed out");
      }

      List<HistoryModel> history =
          backfill.map((b) => b.history.histogram(_scale)).toList();

      // Get longest list of times for rendering as much data as possible
      List<DateTime> times = history.fold(history.first.times, (times, curr) {
        if (curr.times.length > times.length) {
          return curr.times;
        } else {
          return times;
        }
      });

      emit(
        HistoryTableStateData(
          data: HistoryTableModel(
            locations: locations,
            times: times,
            history: history,
          ),
        ),
      );
    } catch (ex, stacktrace) {
      emit(HistoryTableStateEmpty());
    }
  }
}
