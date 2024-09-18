import 'package:authentication_repository/authentication_repository.dart';
import 'package:endless_runner/endless_runner.dart';
import 'package:flutter/widgets.dart';
import 'package:super_dash/main_prod.dart';
import 'package:super_dash/menu_screen.dart';

void startEndlessRunnerApp() {
  AppSwitcher.instance.setApp(
    EndlessRunnerApp(
      backToMenu: AppSwitcher.instance.backToMenu,
    ),
  );
}

/// A singleton class representing the Wallet module in the application.
/// It initializes and provides access to controllers and pages related to the Wallet feature.
class AppSwitcher {
  // Private constructor for internal use to ensure singleton pattern.
  AppSwitcher._internal();

  // The single instance of WalletModule.
  static final AppSwitcher _instance = AppSwitcher._internal();

  /// Gets the singleton instance of WalletModule.
  /// Throws an exception if called before the module is initialized.
  static AppSwitcher get instance {
    if (!_hasInit) {
      throw Exception(
        '''WalletModule must be initialized before use. Call WalletModule.init() on main() { WalletModule.init(); }.''',
      );
    }
    return _instance;
  }

  // Flag to indicate whether the WalletModule has been initialized.
  static bool _hasInit = false;

  static late AuthenticationRepository authenticationRepository;

  /// Initializes the WalletModule.
  /// It initializes necessary controllers and sets the _hasInit flag to true.
  /// This method should be called before accessing the instance.
  static Future<void> initialize(
    AuthenticationRepository authRepository,
  ) async {
    if (!_hasInit) {
      _hasInit = true;

      authenticationRepository = authRepository;
    }
  }

  // ValueNotifier para manter o estado da navegação
  final ValueNotifier<Widget> app = ValueNotifier<Widget>(const SizedBox());

  // Método para alterar o app atual
  Future<void> setApp(Widget newApp) async {
    app.value = newApp;
  }

  // Método para voltar ao menu
  Future<void> backToMenu() async {
    app.value = const MenuScreen(
      startSuperDashApp: startSuperDashApp,
      startEndlessRunnerApp: startEndlessRunnerApp,
    );
  }
}
