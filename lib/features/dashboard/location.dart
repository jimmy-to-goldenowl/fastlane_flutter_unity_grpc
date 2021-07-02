import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:loveblocks/features/account/account.dart';
import 'package:loveblocks/features/dashboard/screen/dashboard.dart';
import 'package:loveblocks/features/demo_unity/screen/demo_unity.dart';
import 'package:loveblocks/routers/routes.dart';

class DashboardLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => ['${Routes.dashboard}/:sup'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(key: ValueKey('Home'), title: 'Home', child: DashBoardScreen()),
        if (state.uri.pathSegments.contains('demo_unity'))
          BeamPage(key: ValueKey('demo_unity'), title: 'Demo Unity', child: DemoUnityScreen()),
        if (state.uri.pathSegments.contains('account'))
          BeamPage(key: ValueKey('account'), title: 'Account', child: AccountScreen()),
      ];
}
