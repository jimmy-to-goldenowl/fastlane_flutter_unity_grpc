import 'package:flutter/material.dart';
import 'package:loveblocks/features/sign/screen/signin.dart';
import 'package:loveblocks/features/sign/screen/signup.dart';
import 'package:beamer/beamer.dart';
import 'package:loveblocks/features/sign/screen/splash.dart';
import 'package:loveblocks/routers/routes.dart';

class InitialLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => [Routes.initial];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(key: ValueKey('Loading'), title: 'Loading', child: SplashScreen()),
      ];
}

class SignLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => ['${Routes.signin}/:sup'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(key: ValueKey('Signin'), title: 'Sign in', child: SignInScreen()),
        if (state.uri.pathSegments.contains('signup'))
          BeamPage(key: ValueKey('Signup'), title: 'Sign up', child: SignUpScreen()),
      ];
}
