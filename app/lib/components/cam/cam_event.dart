part of 'cam_bloc.dart';

abstract class CamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CamEventLoad extends CamEvent {}
