import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DrawHistoryWidget extends StatelessWidget {

  final List<int> drawnNumbers;

  List<int> get recent => drawnNumbers.reversed.take(5).toList();


  const DrawHistoryWidget({
    super.key,
    required this.drawnNumbers
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textSecondary),
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
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${drawnNumbers.length} tiré${drawnNumbers.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _RecentDrawQueue(numbers: recent, isEmpty: drawnNumbers.isEmpty),
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
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
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
        color: isLatest ? AppColors.primary : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color:  AppColors.textSecondary),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isLatest ? AppColors.background : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

