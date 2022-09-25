import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:birdup/components/cam/cam_bloc.dart';
import 'package:birdup/repo/src/station_cam.dart';

class CamPage extends StatelessWidget {
  const CamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: const [
              Text(
                'Camera',
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "10m",
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 10.0,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: BlocProvider<CamBloc>(
          create: (_) => CamBloc()..add(CamEventLoad()),
          child: BlocBuilder<CamBloc, CamState>(
            builder: (context, state) {
              if (state is CamStateInit) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ));
              } else if (state is CamStatedLoaded) {
                if (state.images.isEmpty) {
                  return _error("could not load any images");
                } else {
                  return _Body(state.images);
                }
              } else if (state is CamStateError) {
                return _error(state.error);
              } else {
                throw Exception("unhandled cam state");
              }
            },
          ),
        ),
      );

  Widget _error(String message) => Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
      );
}

class _Body extends StatefulWidget {
  final List<StationImage> images;

  const _Body(this.images);

  @override
  State createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  int _i = 0;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: PhotoView(
              imageProvider: MemoryImage(widget.images[_i].image),
              enableRotation: false,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Slider(
              max: widget.images.length - 1,
              min: 0,
              divisions: widget.images.length,
              value: _i.toDouble(),
              onChanged: (v) => setState(() {
                _i = v.toInt();
              }),
              activeColor: Colors.red[300]!,
              inactiveColor: Colors.blueGrey[700]!,
              thumbColor: Colors.red,
            ),
          ),
        ],
      );
}
