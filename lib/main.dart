import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const BingoApp());
}

const _chestnut = Color(0xFF573323);
const _rust = Color(0xFF9B4B2F);
const _cream = Color(0xFFFBF4E9);
const _lightcream =  Color(0xFFFFFCF6);
const _amber = Color(0xFFE5A943);
const _ink = Color(0xFF34271F);
const _muted = Color(0xFF8A786A);

class BingoApp extends StatelessWidget {
  const BingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bingo Mariage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _rust,
          primary: _rust,
          surface: _cream,
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
  final _random = Random();
  final List<int> _drawnNumbers = [];
  List<int> _remainingNumbers = List.generate(75, (index) => index + 1);

  int? get _lastDrawn => _drawnNumbers.isEmpty ? null : _drawnNumbers.last;

  void _drawNumber() {
    if (_remainingNumbers.isEmpty) return;
    setState(() {
      final index = _random.nextInt(_remainingNumbers.length);
      _drawnNumbers.add(_remainingNumbers.removeAt(index));
    });
  }

  void _resetGame() {
    setState(() {
      _drawnNumbers.clear();
      _remainingNumbers = List.generate(75, (index) => index + 1);
    });
  }

  Future<void> _confirmNewGame() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cream,
        title: const Text('Nouvelle partie ?'),
        content: const Text(
          'Le tirage actuel sera effacé. Voulez-vous vraiment recommencer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _rust,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Recommencer'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _resetGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawnSet = _drawnNumbers.toSet();
    final remaining = _remainingNumbers.length;

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
                      _buildTopBar(),
                      const SizedBox(height: 22),
                      _buildDrawPanel(),
                      const SizedBox(height: 6),
                      _buildHeading(remaining),
                      const SizedBox(height: 16),
                      _buildHistory(),
                      const SizedBox(height: 24),
                      _buildGridHeading(),
                      const SizedBox(height: 12),
                      _buildNumberGrid(drawnSet),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _rust,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.casino_rounded, color: _amber, size: 24),
        ),
        const SizedBox(width: 11),
        const Text(
          'BINGO',
          style: TextStyle(
            color: _chestnut,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.2,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: _drawnNumbers.isEmpty ? null : _confirmNewGame,
          icon: const Icon(Icons.refresh_rounded, size: 19),
          label: const Text('Nouvelle partie'),
          style: TextButton.styleFrom(
            foregroundColor: _rust,
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildHeading(int remaining) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 1),
        Text(
          '$remaining numéros restants sur 75',
          style: const TextStyle(color: _muted, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDrawPanel() {
    final number = _lastDrawn;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: _chestnut,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: _chestnut.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'NUMÉRO TIRÉ',
            style: TextStyle(
              color: _cream,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Container(
              key: ValueKey(number),
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: _cream,
                shape: BoxShape.circle,
                border: Border.all(color: _amber, width: 5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number?.toString().padLeft(2, '0') ?? '--',
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 54,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 19),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: _remainingNumbers.isEmpty ? null : _drawNumber,
              icon: AnimatedRotation(
                turns: _drawnNumbers.length.toDouble(),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                child: Icon(
                  _remainingNumbers.isEmpty
                      ? Icons.check_circle_outline_rounded
                      : Icons.casino_rounded,
                  size: 21,
                ),
              ),
              label: Text(
                _remainingNumbers.isEmpty
                    ? 'Partie terminée'
                    : 'Tirer un numéro',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: _amber,
                foregroundColor: _chestnut,
                disabledBackgroundColor: _muted,
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    final recent = _drawnNumbers.reversed.take(5).toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: _lightcream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _chestnut),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  ' 5 derniers tirages',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${_drawnNumbers.length} tiré${_drawnNumbers.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _RecentDrawQueue(numbers: recent, isEmpty: _drawnNumbers.isEmpty),
        ],
      ),
    );
  }

  Widget _buildGridHeading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Text(
            'GRILLE',
            style: TextStyle(
              color: _chestnut,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: _rust,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Déjà tiré',
              style: TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberGrid(Set<int> drawnSet) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _lightcream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _chestnut),
      ),
      child: Column(
        children: [
          for (var row = 0; row < 15; row++)
            Padding(
              padding: EdgeInsets.only(bottom: row == 14 ? 0 : 5),
              child: Row(
                children: [
                  for (var column = 0; column < 5; column++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _NumberCell(
                          number: row * 5 + column + 1,
                          isDrawn: drawnSet.contains(row * 5 + column + 1),
                          isLatest: _lastDrawn == row * 5 + column + 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RecentDrawQueue extends StatefulWidget {
  const _RecentDrawQueue({required this.numbers, required this.isEmpty});

  final List<int> numbers;
  final bool isEmpty;

  @override
  State<_RecentDrawQueue> createState() => _RecentDrawQueueState();
}

class _RecentDrawQueueState extends State<_RecentDrawQueue> {
  static const _animationDuration = Duration(milliseconds: 500);
  static const _spacing = 5.0;

  final List<int> _items = [];
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  double _itemWidth = 42;

  @override
  void didUpdateWidget(covariant _RecentDrawQueue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_items.isEmpty && widget.numbers.length == 1) {
      _insertAtFront(widget.numbers.first);
      return;
    }
    if (widget.numbers.length == _items.length + 1 &&
        _startsWithCurrentQueue()) {
      _insertAtFront(widget.numbers.first);
      return;
    }
    if (_items.length == 5 &&
        widget.numbers.length == 5 &&
        _startsWithCurrentQueue()) {
      _removeFromEnd();
      _insertAtFront(widget.numbers.first);
      return;
    }
    if (widget.numbers.isEmpty) {
      _items.clear();
      _listKey = GlobalKey<AnimatedListState>();
      return;
    }
    if (!_sameNumbers(widget.numbers, _items)) {
      _items
        ..clear()
        ..addAll(widget.numbers);
      _listKey = GlobalKey<AnimatedListState>();
    }
  }

  bool _startsWithCurrentQueue() {
    if (widget.numbers.isEmpty || _items.isEmpty) return false;
    final retainedCount = min(_items.length, 4);
    for (var index = 0; index < retainedCount; index++) {
      if (widget.numbers[index + 1] != _items[index]) return false;
    }
    return true;
  }

  bool _sameNumbers(List<int> first, List<int> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }

  void _insertAtFront(int number) {
    _items.insert(0, number);
    _listKey.currentState?.insertItem(0, duration: _animationDuration);
  }

  void _removeFromEnd() {
    final index = _items.length - 1;
    final removedNumber = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildQueueItem(
        removedNumber,
        animation,
        itemWidth: _itemWidth,
        isExiting: true,
      ),
      duration: Duration(milliseconds: 0),
    );
  }

  Widget _buildQueueItem(
      int number,
      Animation<double> animation, {
        required double itemWidth,
        bool isExiting = false,
      }) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );
    final movement = isExiting
        ? Tween<Offset>(begin: Offset.zero, end: const Offset(0.45, 0))
        : Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero);

    return SizeTransition(
      axis: Axis.horizontal,
      alignment: Alignment(isExiting ? 1 : -1, 0),
      sizeFactor: curvedAnimation,
      child: SlideTransition(
        position: movement.animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: SizedBox(
            width: itemWidth,
            height: 42,
            child: Padding(
              padding: const EdgeInsets.only(right: _spacing),
              child: _HistoryChip(
                label: number.toString().padLeft(2, '0'),
                isLatest: !isExiting && _items.first == number,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _itemWidth = (constraints.maxWidth - _spacing) / 5;

        return SizedBox(
          height: 42,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              AnimatedList(
                key: _listKey,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                initialItemCount: _items.length,
                itemBuilder: (context, index, animation) => _buildQueueItem(
                  _items[index],
                  animation,
                  itemWidth: _itemWidth,
                ),
              ),
              if (widget.isEmpty)
                const Text(
                  'Les numéros tirés apparaîtront ici',
                  style: TextStyle(color: _muted, fontSize: 13),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({required this.label, required this.isLatest});

  final String label;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        color: isLatest ? _amber : _cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color:  _chestnut),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isLatest ? _cream : _chestnut,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _NumberCell extends StatelessWidget {
  const _NumberCell({
    required this.number,
    required this.isDrawn,
    required this.isLatest,
  });

  final int number;
  final bool isDrawn;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    final color = isDrawn ? _rust : _cream;
    return Container(
      key: ValueKey('number-$number'),
      height: 34,
      decoration: BoxDecoration(
        color: isLatest ? _amber : color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color:  _chestnut),
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: TextStyle(
          color: isDrawn? _cream : _chestnut,
          fontSize: 12,
          fontWeight: isLatest ? FontWeight.w900 : FontWeight.w600,
        ),
      ),
    );
  }
}