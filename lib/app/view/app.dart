import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:super_dash/app_lifecycle/sd_app_lifecycle.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/game_intro/game_intro.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:super_dash/map_tester/map_tester.dart';
import 'package:super_dash/settings/settings.dart';
import 'package:super_dash/share/share.dart';

class SuperDashApp extends StatelessWidget {
  const SuperDashApp({
    required this.audioController,
    required this.settingsController,
    required this.shareController,
    required this.authenticationRepository,
    required this.leaderboardRepository,
    required this.backToMenu,
    this.isTesting = false,
    super.key,
  });

  final AudioController audioController;
  final SettingsController settingsController;
  final ShareController shareController;
  final AuthenticationRepository authenticationRepository;
  final LeaderboardRepository leaderboardRepository;
  final VoidCallback backToMenu;
  final bool isTesting;

  @override
  Widget build(BuildContext context) {
    return
        // PopScope(
        //   onPopInvoked: (reason) {
        //     backToMenu.call();
        //     return;
        //   },
        //   child:
        SDAppLifecycleObserver(
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AudioController>(
            create: (context) {
              final lifecycleNotifier = context.read<ValueNotifier<AppLifecycleState>>();
              return audioController..attachLifecycleNotifier(lifecycleNotifier);
            },
            lazy: false,
          ),
          RepositoryProvider<SettingsController>.value(
            value: settingsController,
          ),
          RepositoryProvider<ShareController>.value(
            value: shareController,
          ),
          RepositoryProvider<AuthenticationRepository>.value(
            value: authenticationRepository..signInAnonymously(),
          ),
          RepositoryProvider<LeaderboardRepository>.value(
            value: leaderboardRepository,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Super Dash',
          theme: ThemeData(
            textTheme: AppTextStyles.textTheme,
          ),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: isTesting ? const MapTesterView() : GameIntroPage(backToMenu: backToMenu),
        ),
      ),
      // ),
    );
  }
}
