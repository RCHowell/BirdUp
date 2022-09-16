import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:birdup/components/cam/cam.dart';
import 'package:birdup/components/compass/compass.dart';
import 'package:birdup/components/history_table/history_table_bloc.dart';
import 'package:birdup/components/history_table/history_table_widget.dart';
import 'package:birdup/model/model.pb.dart';
import 'package:birdup/routes.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

final List<Location> locations = [
  Location(
    name: "North",
    id: 14018695,
  ),
  Location(
    name: "South",
    id: 199866,
  ),
  Location(
    name: "LZ",
    id: 1151595,
  ),
];

final Uri _drw = Uri.parse("https://drw.selfip.com");

class RootPage extends StatelessWidget {
  final GlobalKey<_RootBodyState> _body = GlobalKey();

  RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => _FeedbackDialog(),
              );
            },
          ),
          centerTitle: true,
          title: GestureDetector(
            onTap: () async {
              await launchUrl(_drw);
            },
            child: Column(
              children: const [
                Text(
                  'Tiger',
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
                    "drw.selfip.com",
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          actions: [
            IconButton(
              icon: const Icon(Icons.map_outlined),
              onPressed: () {
                context.router.push(const WindgramRoute());
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Phoenix.rebirth(context);
              },
            )
          ],
        ),
        body: _RootBody(key: _body),
      );
}

class _RootBody extends StatefulWidget {
  const _RootBody({required Key key}) : super(key: key);

  @override
  State createState() => _RootBodyState();
}

class _RootBodyState extends State<_RootBody> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Cam(),
          Container(
            height: 128,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: locations
                  .map((station) => Expanded(
                        child: Compass(
                          location: station,
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: BlocProvider<HistoryTableBloc>(
              create: (_) => HistoryTableBloc()
                ..add(
                  HistoryTableEventLoad(
                    locations: locations.where((l) => l.id != 199866).toList(),
                  ),
                ),
              child: BlocBuilder<HistoryTableBloc, HistoryTableState>(
                builder: (ctx, state) {
                  if (state is HistoryTableStateLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  } else if (state is HistoryTableStateData) {
                    return HistoryTableWidget(
                      data: state.data,
                    );
                  } else if (state is HistoryTableStateEmpty) {
                    return const Center(
                      child: Text("unable to connect to the station"),
                    );
                  } else {
                    throw Exception("unhandled state");
                  }
                },
              ),
            ),
          ),
        ],
      );
}

class _FeedbackDialog extends StatelessWidget {
  final Uri _issues = Uri.parse('https://github.com/rchowell/birdup/issues');

  final Uri _contact = Uri.parse(Mailto(
    to: ['contact@birdup.cloud'],
    subject: 'App Contact',
  ).toString());

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Feedback"),
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
              height: 1.6,
            ),
            children: [
              const TextSpan(text: "Contact\n"),
              TextSpan(
                text: "contact@birdup.cloud\n\n",
                style: const TextStyle(
                  color: Colors.redAccent,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await launchUrl(_contact);
                  },
              ),
              const TextSpan(text: "Issues\n"),
              TextSpan(
                  text: "github.com/rchowell/birdup/issues",
                  style: const TextStyle(
                    color: Colors.redAccent,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await launchUrl(_issues);
                    }),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Colors.blueGrey,
            ),
            child: const Text('OK'),
          ),
        ],
      );
}
