import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    required this.startSuperDashApp,
    required this.startEndlessRunnerApp,
    super.key,
  });

  final VoidCallback startSuperDashApp;
  final VoidCallback startEndlessRunnerApp;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: startSuperDashApp,
                child: const Text('Super Dash'),
              ),
              ElevatedButton(
                onPressed: startEndlessRunnerApp,
                child: const Text('Endless Runner'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
