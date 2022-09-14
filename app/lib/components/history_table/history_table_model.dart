part of 'history_table_bloc.dart';

// Does this belong somewhere else?
class HistoryTableModel {
  List<Location> locations;
  List<DateTime> times;
  List<History> history;

  // field count in StationHistory
  final int fields = 5;

  HistoryTableModel({
    required this.locations,
    required this.times,
    required this.history,
  });
}
