part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryEventLoad extends HistoryEvent {

  final int station;

  HistoryEventLoad(this.station);

  @override
  List<Object> get props => [station];
}
