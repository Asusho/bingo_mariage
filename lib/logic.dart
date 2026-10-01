import 'dart:math';
import 'package:flutter/material.dart';

class Logic extends ChangeNotifier {
  final Random _random = Random();
  final List<int> _drawnNumbers = [];
  late List<int> _remainingNumbers;

  Logic() {
    _initGame();
  }

  // --- GETTERS ---
  List<int> get drawnNumbers => List.unmodifiable(_drawnNumbers);
  List<int> get remainingNumbers => List.unmodifiable(_remainingNumbers);
  int? get lastDrawn => _drawnNumbers.isEmpty ? null : _drawnNumbers.last;
  int get remainingCount => _remainingNumbers.length;

  void _initGame() {
    _drawnNumbers.clear();
    _remainingNumbers = List.generate(75, (index) => index + 1);
  }

  void drawNumber() {
    if (_remainingNumbers.isEmpty) return;

    final index = _random.nextInt(_remainingNumbers.length);
    _drawnNumbers.add(_remainingNumbers.removeAt(index));

    notifyListeners();
  }

  void resetGame() {
    _initGame();
    notifyListeners();
  }


}