part of 'history_table_bloc.dart';

class HistoryTableModel {
  List<Location> locations;
  List<DateTime> times;
  List<HistoryModel> history;

  // must match the extension
  static int fields = 6;

  HistoryTableModel({
    required this.locations,
    required this.times,
    required this.history,
  });
}

extension Fields on HistoryModel {
  List<double?> field(int i) {
    switch (i) {
      case 0:
        return avgWindDirection;
      case 1:
        return maxWindSpeed;
      case 2:
        return avgWindSpeed;
      case 3:
        return minWindSpeed;
      case 4:
        return avgTemperature;
      case 5:
        return avgPressure;
      default:
        throw Exception("no field $i for HistoryModel");
    }
  }
}
