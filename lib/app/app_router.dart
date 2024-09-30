import 'package:flutter/material.dart';
import 'package:object_detection_app/pages/home_screen.dart';
import 'package:object_detection_app/pages/local_screen.dart';
import 'package:object_detection_app/pages/splash_screen.dart';
import 'package:object_detection_app/services/tensorflow_service.dart';
import 'package:object_detection_app/view_models/home_view_model.dart';
import 'package:object_detection_app/view_models/local_view_model.dart';
import 'package:provider/provider.dart';

class AppRoute {
  static const splashScreen = '/splashScreen';
  static const homeScreen = '/homeScreen';
  static const localScreen = '/localScreen';

  static final AppRoute _instance = AppRoute._private();
  factory AppRoute() {
    return _instance;
  }
  AppRoute._private();

  static AppRoute get instance => _instance;

  static Widget createProvider<P extends ChangeNotifier>(
    P Function(BuildContext context) provider,
    Widget child,
  ) {
    return ChangeNotifierProvider<P>(
      create: provider,
      builder: (_, __) {
        return child;
      },
    );
  }

  Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return AppPageRoute(builder: (_) => const SplashScreen());
      case homeScreen:
        Duration? duration;
        if (settings.arguments != null) {
          final args = settings.arguments as Map<String, dynamic>;
          if ((args['isWithoutAnimation'] as bool)) {
            duration = Duration.zero;
          }
        }
        return AppPageRoute(
            appTransitionDuration: duration,
            appSettings: settings,
            builder: (_) => ChangeNotifierProvider(
                create: (context) => HomeViewModel(context,
                    Provider.of<TensorFlowService>(context, listen: false)),
                builder: (_, __) => const HomeScreen()));
      case localScreen:
        return AppPageRoute(
            appSettings: settings,
            builder: (_) => ChangeNotifierProvider(
                create: (context) => LocalViewModel(context,
                    Provider.of<TensorFlowService>(context, listen: false)),
                builder: (_, __) => const LocalScreen()));
      default:
        return null;
    }
  }
}

class AppPageRoute extends MaterialPageRoute<Object> {
  Duration? appTransitionDuration;

  RouteSettings? appSettings;

  AppPageRoute(
      {required super.builder, this.appSettings, this.appTransitionDuration});

  @override
  Duration get transitionDuration =>
      appTransitionDuration ?? super.transitionDuration;

  @override
  RouteSettings get settings => appSettings ?? super.settings;
}
