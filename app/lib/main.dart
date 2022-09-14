import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_it/get_it.dart';
import 'package:birdup/repo/station.dart';
import 'package:birdup/routes.dart';

GetIt injector = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
  ]);
  runApp(Phoenix(child: const App()));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  final _router = Routes();
  late final Station station;

  AppState() {
    injector.allowReassignment = true;
    injector.registerSingleton<Station>(StationDrw());
    // injector.registerSingleton<Station>(StationRandom());
    station = injector.get<Station>();
  }

  @override
  void initState() {
    super.initState();
    // TODO handle errors
    station.connect();
  }

  @override
  void dispose() {
    super.dispose();
    station.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ro',
      theme: ThemeData.light().copyWith(
        highlightColor: Colors.redAccent,
      ),
      routeInformationParser: _router.defaultRouteParser(),
      routerDelegate: _router.delegate(),
    );
  }
}
