// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'routes.dart';

class _$Routes extends RootStackRouter {
  _$Routes([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    RootRoute.name: (routeData) {
      final args =
          routeData.argsAs<RootRouteArgs>(orElse: () => const RootRouteArgs());
      return MaterialPageX<dynamic>(
          routeData: routeData, child: RootPage(key: args.key));
    },
    ChartRoute.name: (routeData) {
      final args = routeData.argsAs<ChartRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              ChartPage(name: args.name, station: args.station, key: args.key));
    },
    CamRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const CamPage());
    },
    GramRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: GramPage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(RootRoute.name, path: '/'),
        RouteConfig(ChartRoute.name, path: '/chart-page'),
        RouteConfig(CamRoute.name, path: '/cam-page'),
        RouteConfig(GramRoute.name, path: '/windgram-page')
      ];
}

/// generated route for
/// [RootPage]
class RootRoute extends PageRouteInfo<RootRouteArgs> {
  RootRoute({Key? key})
      : super(RootRoute.name, path: '/', args: RootRouteArgs(key: key));

  static const String name = 'RootRoute';
}

class RootRouteArgs {
  const RootRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'RootRouteArgs{key: $key}';
  }
}

/// generated route for
/// [ChartPage]
class ChartRoute extends PageRouteInfo<ChartRouteArgs> {
  ChartRoute({required String name, required int station, Key? key})
      : super(ChartRoute.name,
            path: '/chart-page',
            args: ChartRouteArgs(name: name, station: station, key: key));

  static const String name = 'ChartRoute';
}

class ChartRouteArgs {
  const ChartRouteArgs({required this.name, required this.station, this.key});

  final String name;

  final int station;

  final Key? key;

  @override
  String toString() {
    return 'ChartRouteArgs{name: $name, station: $station, key: $key}';
  }
}

/// generated route for
/// [CamPage]
class CamRoute extends PageRouteInfo<void> {
  const CamRoute() : super(CamRoute.name, path: '/cam-page');

  static const String name = 'CamRoute';
}

/// generated route for
/// [GramPage]
class GramRoute extends PageRouteInfo<void> {
  const GramRoute() : super(GramRoute.name, path: '/gram-page');

  static const String name = 'GramRoute';
}
