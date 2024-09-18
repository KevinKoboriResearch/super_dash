import 'package:endless_runner/endless_runner.dart';
import 'package:endless_runner/src/audio/sounds.dart';
import 'package:endless_runner/src/game/endless_runner.dart';
import 'package:endless_runner/src/game/game_screen.dart';
import 'package:endless_runner/src/player_progress/persistence/memory_player_progress_persistence.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test menus', (tester) async {
    // Build our game and trigger a frame.
    // TODO(Kevin): fix this test
    // await tester.pumpWidget(const MyGame());
    await tester.pumpWidget(const MainMenuScreen(key: Key('main menu')));

    // Verify that the 'Play' button is shown.
    expect(find.text('Play'), findsOneWidget);

    // Verify that the 'Settings' button is shown.
    expect(find.text('Settings'), findsOneWidget);

    // Go to 'Settings'.
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Music'), findsOneWidget);

    // Go back to main menu.
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Tap 'Play'.
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();
    expect(find.text('Select level'), findsOneWidget);

    // Tap level 1.
    await tester.tap(find.text('Level #1'));
    await tester.pump();
  });

  testWithGame(
    'smoke test flame game',
    () {
      return EndlessRunner(
        level: (
          number: 1,
          winScore: 3,
          canSpawnTall: false,
        ),
        playerProgress: PlayerProgress(
          store: MemoryOnlyPlayerProgressPersistence(),
        ),
        audioController: _MockAudioController(),
      );
    },
    (game) async {
      game.overlays.addEntry(
        GameScreen.backButtonKey,
        (context, game) => Container(),
      );
      game.overlays.addEntry(
        GameScreen.winDialogKey,
        (context, game) => Container(),
      );
      await game.onLoad();
      game.update(0);
      expect(game.children.length, 3);
      expect(game.world.children.length, 2);
      expect(game.camera.viewport.children.length, 2);
      expect(game.world.player.isLoading, isTrue);
    },
  );
}

class _MockAudioController implements ERAudioController {
  @override
  void attachDependencies(ERAppLifecycleStateNotifier lifecycleNotifier,
      ERSettingsController settingsController) {}

  @override
  void dispose() {}

  @override
  void playSfx(SfxType type) {}
}
