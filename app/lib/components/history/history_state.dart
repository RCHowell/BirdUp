part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryStateLoading extends HistoryState {}

class HistoryStateData extends HistoryState {

  final HistoryModel history;
  final HistoryScale scale;

  HistoryStateData(this.history, this.scale);

  @override
  List<Object> get props => [history, scale];
}

class HistoryStateError extends HistoryState {

  final String message;

  HistoryStateError(this.message);

  @override
  List<Object> get props => [message];
}
