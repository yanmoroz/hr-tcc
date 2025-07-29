import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  /// Formats a timestamp for display in Russian with relative dates
  /// Returns formats like: "Сегодня в 14:30", "Вчера в 09:15", "27 июля в 16:45"
  static String formatRelativeTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

    final difference = today.difference(date).inDays;
    final timePart = DateFormat('HH:mm', 'ru').format(timestamp);

    if (difference == 0) {
      return 'Сегодня в $timePart';
    } else if (difference == 1) {
      return 'Вчера в $timePart';
    } else {
      final datePart = DateFormat('dd MMMM', 'ru').format(timestamp);
      return '$datePart в $timePart';
    }
  }

  /// Formats a date in DD.MM.YYYY format
  /// Returns format like: "27.07.2024"
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  /// Formats a date range in DD.MM.YYYY - DD.MM.YYYY format
  /// Returns format like: "27.07.2024 - 30.07.2024"
  static String formatDateRange(DateTimeRange range) {
    return '${formatDate(range.start)} - ${formatDate(range.end)}';
  }

  /// Formats a date with time in DD.MM.YYYY в HH:mm format
  /// Returns format like: "27.07.2024 в 14:30"
  static String formatDateTime(DateTime dateTime) {
    final datePart = formatDate(dateTime);
    final timePart = DateFormat('HH:mm').format(dateTime);
    return '$datePart в $timePart';
  }

  /// Formats a date for grouping (Today, Yesterday, Earlier)
  /// Returns: "Сегодня", "Вчера", or formatted date
  static String formatDateForGrouping(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0 && now.day == date.day) {
      return 'Сегодня';
    } else if (diff.inDays == 1 ||
        (diff.inHours < 48 && now.day - date.day == 1)) {
      return 'Вчера';
    } else {
      return DateFormat('d MMMM', 'ru').format(date);
    }
  }

  /// Formats time only in HH:mm format
  /// Returns format like: "14:30"
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Formats month name in Russian
  /// Returns format like: "Июль"
  static String formatMonth(DateTime date) {
    return DateFormat('MMMM', 'ru').format(date);
  }

  /// Formats day and month in Russian
  /// Returns format like: "27 июля"
  static String formatDayMonth(DateTime date) {
    return DateFormat('d MMMM', 'ru').format(date);
  }
}
