import 'dart:async';

// import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // TODO(ChatGPT): qual seria o melhor log aqui? info, warning, error, etc?
    _logger.i('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    // TODO(ChatGPT): qual seria o melhor log aqui? info, warning, error, etc?
    _logger.e('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

typedef BootstrapBuilder = FutureOr<Widget> Function(
  FirebaseAuth firebaseAuth,
);

Future<void> bootstrap(BootstrapBuilder builder) async {
  FlutterError.onError = (details) {
    // TODO(ChatGPT): qual seria o melhor log aqui? info, warning, error, etc?
    _logger.e(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  runApp(
    await builder(
      FirebaseAuth.instance,
    ),
  );
}
