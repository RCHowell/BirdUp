import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'pages/pages.dart';

part 'routes.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: RootPage, initial: true),
    AutoRoute(page: ChartPage),
    AutoRoute(page: CamPage),
    AutoRoute(page: WindgramPage),
  ],
)

class Routes extends _$Routes {}
