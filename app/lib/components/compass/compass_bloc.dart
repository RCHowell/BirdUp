import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:birdup/model/model.pb.dart';
import 'package:birdup/repo/station.dart';

part 'compass_event.dart';
part 'compass_state.dart';

GetIt injector = GetIt.instance;

class CompassBloc extends Bloc<CompassEvent, CompassState> {
  late final Station station;

  CompassBloc() : super(const CompassStateData(null)) {
    station = injector.get<Station>();
    on<CompassEventListen>(_onListen);
    on<CompassEventUpdate>((e, emit) => emit(CompassStateData(e.sample)));
  }

  Future<void> _onListen(
    CompassEventListen event,
    Emitter<CompassState> emit,
  ) async {
    station.on<StationResData>(event.location, (data) {
      add(CompassEventUpdate(data.sample));
    });
    station.emit(StationReqListen(event.location));
  }
}
