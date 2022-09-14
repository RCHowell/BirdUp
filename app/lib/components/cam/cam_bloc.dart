import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:birdup/repo/src/station_cam.dart';

part 'cam_event.dart';

part 'cam_state.dart';

class CamBloc extends Bloc<CamEvent, CamState> {
  final StationCam _cam = StationCam();

  CamBloc() : super(CamStateInit()) {
    on<CamEventLoad>((event, emit) async {
      try {
        List<NullableStationImage> nullableImages = await _cam.load();
        List<StationImage> images = nullableImages
            .where((i) => i.timestamp != null && i.image != null)
            .map((i) => StationImage(
                  timestamp: i.timestamp!,
                  image: i.image!,
                ))
            .toList();
        images.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        emit(CamStatedLoaded(
          images: images,
        ));
      } catch (ex) {
        emit(CamStateError(ex.toString()));
      }
    });
  }
}
