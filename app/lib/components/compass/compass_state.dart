part of 'compass_bloc.dart';

abstract class CompassState extends Equatable {
  const CompassState();

  @override
  List<Object> get props => [];
}

class CompassStateData extends CompassState {
  final Sample? sample;

  const CompassStateData(this.sample);

  @override
  List<Object> get props => (sample == null) ? [] : [sample!];
}
