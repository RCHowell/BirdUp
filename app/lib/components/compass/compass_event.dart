part of 'compass_bloc.dart';

abstract class CompassEvent extends Equatable {
  const CompassEvent();

  @override
  List<Object> get props => [];
}

class CompassEventListen extends CompassEvent {
  final int location;

  const CompassEventListen(this.location);

  @override
  List<Object> get props => [location];
}

class CompassEventUpdate extends CompassEvent {
  final Sample sample;

  const CompassEventUpdate(this.sample);

  @override
  List<Object> get props => [sample.hashCode];
}
