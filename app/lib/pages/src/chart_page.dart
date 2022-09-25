import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:birdup/components/history/history_bloc.dart';
import 'package:birdup/components/history/history_charts.dart';

class ChartPage extends StatelessWidget {
  // AutoRoute didn't like generated "Location" object as a param
  final String name;
  final int station;

  const ChartPage({
    required this.name,
    required this.station,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "4hr • 1m",
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
        body: BlocProvider<HistoryBloc>(
          create: (_) => HistoryBloc()..add(HistoryEventLoad(station)),
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is HistoryStateError) {
                return Center(child: Text("ERROR: ${state.message}"));
              } else if (state is HistoryStateLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HistoryStateData) {
                return HistoryCharts(
                  station: station,
                  state: state,
                );
              } else {
                throw Exception("unhandled HistoryState: $state");
              }
            },
          ),
        ),
      );
}

