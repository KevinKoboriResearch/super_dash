import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game/game_screen.dart';
import '../main_menu/main_menu_screen.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/wobbly_button.dart';
import 'instructions_dialog.dart';
import 'levels.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const LevelSelectionScreen(
        key: Key('level selection'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();
    final levelTextStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4);

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection.color,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select level',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 16),
                  NesButton(
                    type: NesButtonType.normal,
                    child: NesIcon(iconData: NesIcons.questionMark),
                    onPressed: () {
                      NesDialog.show<void>(
                        context: context,
                        builder: (_) => const InstructionsDialog(),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: SizedBox(
              width: 450,
              child: ListView(
                children: [
                  for (final level in gameLevels)
                    ListTile(
                      enabled: playerProgress.levels.length >= level.number - 1,
                      onTap: () {
                        final audioController = context.read<ERAudioController>();
                        audioController.playSfx(SfxType.buttonTap);

                        Navigator.of(context).push(GameScreen.route(level));
                      },
                      leading: Text(
                        level.number.toString(),
                        style: levelTextStyle,
                      ),
                      title: Row(
                        children: [
                          Text(
                            'Level #${level.number}',
                            style: levelTextStyle,
                          ),
                          if (playerProgress.levels.length <
                              level.number - 1) ...[
                            const SizedBox(width: 10),
                            const Icon(Icons.lock, size: 20),
                          ] else if (playerProgress.levels.length >=
                              level.number) ...[
                            const SizedBox(width: 50),
                            Text(
                              '${playerProgress.levels[level.number - 1]}s',
                              style: levelTextStyle,
                            ),
                          ],
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          WobblyButton(
            onPressed: () {
              Navigator.of(context).push(MainMenuScreen.route());
            },
            child: const Text('Back'),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
