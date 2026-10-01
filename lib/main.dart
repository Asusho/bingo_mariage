import 'package:flutter/material.dart';

import 'theme/app_colors.dart';
import 'logic.dart';
import 'widgets/top_bar_widget.dart';
import 'widgets/draw_panel_widget.dart';
import 'widgets/draw_info_widget.dart';
import 'widgets/draw_history_widget.dart';
import 'widgets/grid_widget.dart';

void main() {
  runApp(const BingoApp());
}

class BingoApp extends StatelessWidget {
  const BingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bingo Mariage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.secondary,
          primary: AppColors.secondary,
          surface: AppColors.background,
        ),
        fontFamily: 'Roboto',
      ),
      home: const BingoPage(),
    );
  }
}

class BingoPage extends StatefulWidget {
  const BingoPage({super.key});

  @override
  State<BingoPage> createState() => _BingoPageState();
}

class _BingoPageState extends State<BingoPage> {
  final Logic _game = Logic();

  @override
  void dispose() {
    _game.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _game,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          TopBar(
                            drawnNumbers: _game.drawnNumbers,
                              onResetConfirmed: () => _game.resetGame()
                          ),
                          const SizedBox(height: 22),
                          DrawPanelWidget(
                            number: _game.lastDrawn,
                            remainingNumbers: _game.remainingNumbers,
                            drawnNumbers: _game.drawnNumbers,
                            drawNumber: _game.drawNumber,
                          ),
                          const SizedBox(height: 6),
                          DrawInfoWidget(remaining: _game.remainingCount),
                          const SizedBox(height: 16),
                          DrawHistoryWidget(drawnNumbers: _game.drawnNumbers),
                          const SizedBox(height: 24),
                          GridWidget(
                            drawnNumbers: _game.drawnNumbers,
                            lastDrawn: _game.lastDrawn,
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}