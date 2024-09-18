import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:super_dash/app/app.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/bootstrap.dart';
import 'package:super_dash/firebase_options_dev.dart';
import 'package:super_dash/settings/persistence/persistence.dart';
import 'package:super_dash/settings/settings.dart';
import 'package:super_dash/share/share.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );

  final audio = AudioController()..attachSettings(settings);

  await audio.initialize();

  final share = ShareController(
    gameUrl: 'https://endless-runner-9481713-383737.web.app/',
  );

  final leaderboardRepository = LeaderboardRepository(
    FirebaseFirestore.instance,
  );

  unawaited(
    bootstrap(
      (firebaseAuth) async {
        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: firebaseAuth,
        );

        final appSwitcher = AppSwitcher();

        final menu = MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      appSwitcher.setApp(
                        SuperDashApp(
                          audioController: audio,
                          settingsController: settings,
                          shareController: share,
                          authenticationRepository: authenticationRepository,
                          leaderboardRepository: leaderboardRepository,
                        ),
                      );
                    },
                    child: const Text('Super Dash'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // appSwitcher.setApp(EndlessRunnerApp());
                    },
                    child: const Text('Endless Runner'),
                  ),
                ],
              ),
            ),
          ),
        );

        appSwitcher.setApp(menu);

        return ValueListenableBuilder<Widget>(
          valueListenable: appSwitcher.app,
          builder: (_, value, __) {
            return value;
          },
        );
      },
    ),
  );
}
