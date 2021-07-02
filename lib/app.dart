import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loveblocks/src/bloc/app_bloc/app_bloc.dart';
import 'package:loveblocks/src/dialogs/dialog_service.dart';
import 'package:loveblocks/routers/router.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routerDelegate = AppRouter.routerDelegate;
    return BeamerProvider(
      routerDelegate: routerDelegate,
      child: MaterialApp.router(
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
        backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate),
        builder: DialogService.initBuilder,
      ),
    );
  }
}
