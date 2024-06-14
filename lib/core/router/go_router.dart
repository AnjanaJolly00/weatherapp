// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/presentation/screens/weather_home/provider/weather_provider.dart';
import 'package:weatherapp/presentation/screens/weather_home/weather_home_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

abstract class Routes {
  static const HOME = "/";
}

final GoRouter route = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: Routes.HOME,
  routes: [
    GoRoute(
      path: Routes.HOME,
      builder: (context, state) => ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
          builder: (context, child) {
            return const WeatherHomeScreen();
          }),
    ),

    // GoRoute(
    //   name: Routes.LOAN_AVAILABILITY,
    //   path: Routes.LOAN_AVAILABILITY,
    //   builder: (context, state) => ChangeNotifierProvider(
    //       create: (_) => LoanAvailabilityProvider(),
    //       builder: (context, child) {
    //         return LoanAvailabilityScreen(
    //             isFromHome: state.pathParameters['isFromHome'] == 'true');
    //       }),
    // ),
  ],
);

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0), // You can adjust the values here
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  );
}
