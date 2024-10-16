/// Repository to manage authentication.
library endless_runner;

import 'package:endless_runner/endless_runner.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

export 'src/app_lifecycle/er_app_lifecycle.dart';
export 'src/audio/audio_controller.dart';
export 'src/main_menu/main_menu_screen.dart';
export 'src/player_progress/player_progress.dart';
export 'src/settings/settings.dart';
export 'src/style/palette.dart';

class EndlessRunnerApp extends StatelessWidget {
  const EndlessRunnerApp({
    required this.backToMenu,
    super.key,
  });

  final VoidCallback backToMenu;

  @override
  Widget build(BuildContext context) {
    return
        // PopScope(
        //   onPopInvoked: (reason) {
        //     backToMenu.call();
        //     return;
        //   },
        //   child:
        ERAppLifecycleObserver(
      child: MultiProvider(
        providers: [
          Provider(create: (context) => backToMenu),
          Provider(create: (context) => Palette()),
          ChangeNotifierProvider(create: (context) => PlayerProgress()),
          Provider(create: (context) => ERSettingsController()),
          // Set up audio.
          ProxyProvider2<ERSettingsController, ERAppLifecycleStateNotifier, ERAudioController>(
            // Ensures that music starts immediately.
            lazy: false,
            create: (context) => ERAudioController(),
            update: (context, settings, lifecycleNotifier, audio) {
              audio!.attachDependencies(lifecycleNotifier, settings);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          ),
        ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();

          return MaterialApp(
            title: 'Endless Runner',
            debugShowCheckedModeBanner: false,
            theme: flutterNesTheme().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.seed.color,
                surface: palette.backgroundMain.color,
              ),
              textTheme: GoogleFonts.pressStart2pTextTheme().apply(
                bodyColor: palette.text.color,
                displayColor: palette.text.color,
              ),
            ),
            home: const MainMenuScreen(key: Key('main menu')),
          );
        }),
      ),
      // ),
    );
  }
}
