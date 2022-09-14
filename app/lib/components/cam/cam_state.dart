part of 'cam_bloc.dart';

abstract class CamState extends Equatable {
  @override
  List<Object> get props => [];
}

class CamStateInit extends CamState {}

class CamStatedLoaded extends CamState {
  final List<StationImage> images;

  CamStatedLoaded({
    required this.images,
  });

  @override
  List<Object> get props => images;
}

class CamStateError extends CamState {

  final String error;

  CamStateError(this.error);

  @override
  List<Object> get props => [error];
}
