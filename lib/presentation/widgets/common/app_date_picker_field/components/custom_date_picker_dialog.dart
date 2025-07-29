import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

import '../../../../../core/utils/date_utils.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final AppDatePickerMode mode;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTimeRange>? onRangeSelected;
  final DateTimeRange? initialRange;
  final bool showPastDates;

  const CustomDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.mode,
    this.onDateSelected,
    this.onRangeSelected,
    this.initialRange,
    this.showPastDates = false,
  });

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog>
    with SingleTickerProviderStateMixin {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool get _isRangeMode => widget.mode == AppDatePickerMode.range;
  bool _showYearPicker = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const List<String> _monthNames = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];
  static const List<String> _weekdayNames = [
    'Пн',
    'Вт',
    'Ср',
    'Чт',
    'Пт',
    'Сб',
    'Вс',
  ];

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  @override
  void initState() {
    super.initState();
    // Если initialDate вне диапазона, используем firstDate (только дата)
    final initial = _dateOnly(widget.initialDate);
    final first = _dateOnly(widget.firstDate);
    final last = _dateOnly(widget.lastDate);
    _selectedDate =
        initial.isBefore(first) || initial.isAfter(last) ? first : initial;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
    // Если выбранная дата невалидна, ищем первую доступную дату в месяце
    if (!_isWithinRange(_selectedDate)) {
      final daysInMonth = DateUtils.getDaysInMonth(
        _displayedMonth.year,
        _displayedMonth.month,
      );
      DateTime? firstAvailable;
      for (int day = 1; day <= daysInMonth; day++) {
        final candidate = DateTime(
          _displayedMonth.year,
          _displayedMonth.month,
          day,
        );
        if (_isWithinRange(candidate)) {
          firstAvailable = candidate;
          break;
        }
      }
      _selectedDate = firstAvailable ?? first;
    }
    if (_isRangeMode && widget.initialRange != null) {
      _rangeStart = widget.initialRange!.start;
      _rangeEnd = widget.initialRange!.end;
    }
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.value = 1.0;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _changeMonth(int delta) async {
    await _fadeController.reverse();
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + delta,
      );
    });
    await _fadeController.forward();
  }

  Future<void> _changeYear(int year) async {
    await _fadeController.reverse();
    setState(() {
      _displayedMonth = DateTime(year, _displayedMonth.month);
      _showYearPicker = false;
    });
    await _fadeController.forward();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isWithinRange(DateTime date) =>
      !date.isBefore(widget.firstDate) && !date.isAfter(widget.lastDate);

  void _onDayTap(DateTime date) {
    if (!_isRangeMode) {
      setState(() {
        _selectedDate = date;
      });
    } else {
      setState(() {
        if (_rangeStart == null && _rangeEnd == null) {
          _rangeStart = date;
        } else if (_rangeStart != null && _rangeEnd == null) {
          if (date.isBefore(_rangeStart!)) {
            _rangeEnd = _rangeStart;
            _rangeStart = date;
          } else if (date.isAfter(_rangeStart!)) {
            _rangeEnd = date;
          } else {
            _rangeEnd = date;
          }
        } else {
          _rangeStart = date;
          _rangeEnd = null;
        }
        // Ensure start <= end
        if (_rangeStart != null &&
            _rangeEnd != null &&
            _rangeStart!.isAfter(_rangeEnd!)) {
          final tmp = _rangeStart;
          _rangeStart = _rangeEnd;
          _rangeEnd = tmp;
        }
      });
    }
  }

  bool _isInRange(DateTime date) {
    if (_rangeStart != null && _rangeEnd != null) {
      return !date.isBefore(_rangeStart!) && !date.isAfter(_rangeEnd!);
    }
    return false;
  }

  bool _isRangeEdge(DateTime date) {
    return (date == _rangeStart || date == _rangeEnd);
  }

  bool _isPast(DateTime date, bool showPastDate) {
    if (showPastDate) {
      return false;
    }
    final now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day));
  }

  List<int> get _yearList {
    final current = _displayedMonth.year;
    final minYear = widget.firstDate.year;
    final maxYear = widget.lastDate.year;
    final start = (current - 10).clamp(minYear, maxYear - 20);
    // final end = (current + 10).clamp(minYear + 20, maxYear);
    return List.generate(
      21,
      (i) => start + i,
    ).where((y) => y >= minYear && y <= maxYear).toList();
  }

  double get _modalHeight {
    // Базовая высота для календаря + кнопка
    double base = 620;
    // Если есть плашка выбранного диапазона — увеличиваем
    if (_isRangeMode && (_rangeStart != null || _rangeEnd != null)) {
      base += 48;
    }
    // Если открыт выбор года — делаем ниже (фиксированно)
    if (_showYearPicker) {
      base = 560;
    }
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final firstWeekday =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday;
    final startOffset = (firstWeekday + 6) % 7; // Понедельник - первый день
    final totalCells = ((daysInMonth + startOffset) / 7).ceil() * 7;

    return SafeArea(
      bottom: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        constraints: BoxConstraints(minHeight: 360, maxHeight: _modalHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Заголовок
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 24,
                    right: 24,
                    bottom: 0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isRangeMode
                              ? 'Выберите дату или период'
                              : 'Выберите дату',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),
                // Выбранная дата/период
                if (_isRangeMode && (_rangeStart != null))
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 8,
                      bottom: 0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gray100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _rangeEnd == null
                                    ? AppDateUtils.formatDate(_rangeStart!)
                                    : '${AppDateUtils.formatDate(_rangeStart!)} - ${AppDateUtils.formatDate(_rangeEnd!)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rangeStart = null;
                                    _rangeEnd = null;
                                  });
                                },
                                child: const Icon(Icons.close, size: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                // Месяц и стрелки и выбор года
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => _changeMonth(-1),
                      ),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _monthNames[_displayedMonth.month - 1],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showYearPicker = !_showYearPicker;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      '${_displayedMonth.year}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => _changeMonth(1),
                      ),
                    ],
                  ),
                ),
                if (_showYearPicker)
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 2.2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      children:
                          _yearList
                              .map(
                                (y) => GestureDetector(
                                  onTap: () => _changeYear(y),
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color:
                                          y == _displayedMonth.year
                                              ? AppColors.gray200
                                              : null,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$y',
                                        style: TextStyle(
                                          fontWeight:
                                              y == _displayedMonth.year
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                if (!_showYearPicker) ...[
                  const SizedBox(height: 8),
                  // Дни недели
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: List.generate(7, (i) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              _weekdayNames[i],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Сетка дней и кнопка "Выбрать" в Expanded
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: AnimatedBuilder(
                              animation: _fadeAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _fadeAnimation.value,
                                  child: child,
                                );
                              },
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final cellSize =
                                      (constraints.maxWidth - 8) / 7;
                                  return GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: totalCells,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 7,
                                          mainAxisSpacing: 4,
                                          crossAxisSpacing: 4,
                                        ),
                                    itemBuilder: (context, index) {
                                      final dayNum = index - startOffset + 1;
                                      final isInMonth =
                                          dayNum > 0 && dayNum <= daysInMonth;
                                      if (!isInMonth) {
                                        return const SizedBox.shrink();
                                      }
                                      final date = DateTime(
                                        _displayedMonth.year,
                                        _displayedMonth.month,
                                        dayNum,
                                      );
                                      final isPast =
                                          _isPast(date, widget.showPastDates) ||
                                          !_isWithinRange(date);
                                      final isSelected =
                                          !_isRangeMode &&
                                          _isSameDay(date, _selectedDate);
                                      final isRangeEdge =
                                          _isRangeMode && _isRangeEdge(date);
                                      final isInRange =
                                          _isRangeMode && _isInRange(date);
                                      final isEnabled = !isPast;
                                      Color? bgColor;
                                      if (isSelected || isRangeEdge) {
                                        bgColor = const Color(0xFF1A357B);
                                      } else if (isInRange) {
                                        bgColor = AppColors.gray200;
                                      }
                                      return Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          onTap:
                                              isEnabled
                                                  ? () => _onDayTap(date)
                                                  : null,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: cellSize,
                                            width: cellSize,
                                            decoration:
                                                bgColor != null
                                                    ? BoxDecoration(
                                                      color: bgColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    )
                                                    : null,
                                            child: Text(
                                              '$dayNum',
                                              style: TextStyle(
                                                color:
                                                    isPast
                                                        ? AppColors.gray500
                                                        : (isSelected ||
                                                                isRangeEdge
                                                            ? Colors.white
                                                            : Colors.black),
                                                fontWeight:
                                                    (isSelected || isRangeEdge)
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Кнопка "Выбрать"
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            child: SizedBox(
                              width: double.infinity,
                              child: AppButton(
                                variant: AppButtonVariant.secondary,
                                text: 'Выбрать',
                                onPressed:
                                    _isRangeMode
                                        ? (_rangeStart != null &&
                                                _rangeEnd != null
                                            ? () {
                                              widget.onRangeSelected?.call(
                                                DateTimeRange(
                                                  start: _rangeStart!,
                                                  end: _rangeEnd!,
                                                ),
                                              );
                                              context.pop();
                                            }
                                            : null)
                                        : () {
                                          widget.onDateSelected?.call(
                                            _selectedDate,
                                          );
                                          context.pop();
                                        },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomDatePickerBottomSheet({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  required AppDatePickerMode mode,
  required bool showPastDates,
  ValueChanged<DateTime>? onDateSelected,
  ValueChanged<DateTimeRange>? onRangeSelected,
  DateTimeRange? initialRange,
}) {
  showGeneralDialog(
    context: context,
    barrierLabel: 'DatePicker',
    barrierDismissible: true,
    barrierColor: AppColors.black.withValues(alpha: 0.6),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, anim1, anim2) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(color: Colors.transparent),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: CustomDatePickerDialog(
                initialDate: initialDate,
                firstDate: firstDate,
                lastDate: lastDate,
                mode: mode,
                onDateSelected: onDateSelected,
                onRangeSelected: onRangeSelected,
                initialRange: initialRange,
                showPastDates: showPastDates,
              ),
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}
