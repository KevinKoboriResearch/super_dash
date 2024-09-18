import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:super_dash/app/app.dart';
import 'package:super_dash/app_switcher.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/bootstrap.dart';
import 'package:super_dash/firebase_options_dev.dart';
import 'package:super_dash/menu_screen.dart';
import 'package:super_dash/settings/persistence/persistence.dart';
import 'package:super_dash/settings/settings.dart';
import 'package:super_dash/share/share.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  unawaited(
    bootstrap(
      (firebaseAuth) async {
        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: firebaseAuth,
        );

        await AppSwitcher.initialize(authenticationRepository);

        await AppSwitcher.instance.setApp(
          MenuScreen(
            startSuperDashApp: () =>
                startSuperDashApp(authenticationRepository),
            startEndlessRunnerApp: () =>
                startEndlessRunnerApp(authenticationRepository),
          ),
        );

        return ValueListenableBuilder<Widget>(
          valueListenable: AppSwitcher.instance.app,
          builder: (_, value, __) {
            return value;
          },
        );
      },
    ),
  );
}

void startSuperDashApp(
  AuthenticationRepository authenticationRepository,
) {
  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );

  final audio = AudioController()..attachSettings(settings);

  final share = ShareController(
    gameUrl: 'https://superdash.flutter.dev/',
  );

  final leaderboardRepository = LeaderboardRepository(
    FirebaseFirestore.instance,
  );

  AppSwitcher.instance.setApp(
    SuperDashApp(
      audioController: audio,
      settingsController: settings,
      shareController: share,
      authenticationRepository: authenticationRepository,
      leaderboardRepository: leaderboardRepository,
      backToMenu: () =>
          AppSwitcher.instance.backToMenu(authenticationRepository),
    ),
  );
}
