import 'package:beamer/beamer.dart';
import 'package:loveblocks/features/dashboard/location.dart';
import 'package:loveblocks/features/sign/location.dart';
import 'package:loveblocks/routers/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loveblocks/src/bloc/app_bloc/app_bloc.dart';

class AppRouter {
  static final routerDelegate = BeamerDelegate(
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        InitialLocation(),
        SignLocation(),
        DashboardLocation(),
      ],
    ),
    guards: [
      BeamGuard(
        pathBlueprints: [Routes.initial],
        check: (context, state) =>
            context.select((AppBloc state) => state.isInitial || state.isUnauthenticated),
        beamToNamed: Routes.dashboard,
      ),
      BeamGuard(
        pathBlueprints: [Routes.initial],
        check: (context, state) =>
            context.select((AppBloc state) => state.isInitial || state.isAuthenticated),
        beamToNamed: Routes.signin,
      ),
      // Guard /login if the user is unauthenticated:
      BeamGuard(
        pathBlueprints: ['${Routes.dashboard}*'],
        check: (context, state) => context.select((AppBloc auth) => auth.isAuthenticated),
        beamToNamed: Routes.signin,
      ),
      // Guard /dashboard if the user is authenticated:
      BeamGuard(
        pathBlueprints: ['${Routes.signin}*'],
        check: (context, state) => context.select((AppBloc auth) => auth.isUnauthenticated),
        beamToNamed: Routes.dashboard,
      ),
    ],
    initialPath: Routes.initial,
  );
}
