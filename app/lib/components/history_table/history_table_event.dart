part of 'history_table_bloc.dart';

abstract class HistoryTableEvent extends Equatable {
  const HistoryTableEvent();

  @override
  List<Object> get props => [];
}

class HistoryTableEventLoad extends HistoryTableEvent {
  final List<Location> locations;

  const HistoryTableEventLoad({
    required this.locations,
  });

  @override
  List<Object> get props => locations;
}
