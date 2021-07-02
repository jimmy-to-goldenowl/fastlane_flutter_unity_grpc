import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loveblocks/routers/routes.dart';
import 'package:loveblocks/src/bloc/app_bloc/app_bloc.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            title: Text('Demo Unity'),
            onTap: () => Beamer.of(context).beamToNamed(Routes.demoUnity),
          ),
          Divider(),
          ListTile(
            title: Text('Account'),
            onTap: () => Beamer.of(context).beamToNamed(Routes.account),
          ),
          Divider(),
          ListTile(
            key: Key('logout_button'),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => context.read<AppBloc>().add(AppLogoutRequested()),
          ),
        ],
      ),
    );
  }
}
