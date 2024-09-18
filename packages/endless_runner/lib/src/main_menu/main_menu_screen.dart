import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../level_selection/level_selection_screen.dart';
import '../settings/settings.dart';
import '../settings/settings_screen.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import '../style/wobbly_button.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const MainMenuScreen(key: Key('main menu')),
    );
  }

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();

  static const _gap = SizedBox(height: 10);
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    Flame.device.setLandscape();
    Flame.device.fullScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<ERSettingsController>();
    final audioController = context.watch<ERAudioController>();
    final backToMenu = context.watch<VoidCallback>();

    return Scaffold(
      backgroundColor: palette.backgroundMain.color,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/endless_runner/banner.png',
                filterQuality: FilterQuality.none,
              ),
              MainMenuScreen._gap,
              Transform.rotate(
                angle: -0.1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const Text(
                    'A Flutter game template.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Press Start 2P',
                      fontSize: 32,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WobblyButton(
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                Navigator.of(context).push(LevelSelectionScreen.route());
              },
              child: const Text('Play'),
            ),
            MainMenuScreen._gap,
            WobblyButton(
              onPressed: () =>
                  Navigator.of(context).push(SettingsScreen.route()),
              child: const Text('Settings'),
            ),
            MainMenuScreen._gap,
            WobblyButton(
              onPressed: () {
               backToMenu.call();
              },
              child: const Text('Back to Menu'),
            ),
            MainMenuScreen._gap,
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.audioOn,
                builder: (context, audioOn, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleAudioOn(),
                    icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
                  );
                },
              ),
            ),
            MainMenuScreen._gap,
            const Text('Built with Flame'),
          ],
        ),
      ),
    );
  }
}
