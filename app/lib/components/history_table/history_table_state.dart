part of 'history_table_bloc.dart';

abstract class HistoryTableState extends Equatable {
  const HistoryTableState();

  @override
  List<Object> get props => [];
}

class HistoryTableStateLoading extends HistoryTableState {}

class HistoryTableStateEmpty extends HistoryTableState {}

class HistoryTableStateData extends HistoryTableState {
  final HistoryTableModel data;

  const HistoryTableStateData({
    required this.data,
  });

  @override
  List<Object> get props => data.times;
}
