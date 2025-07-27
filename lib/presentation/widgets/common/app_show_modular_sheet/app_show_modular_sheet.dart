import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/themes/themes.dart';
import 'components/app_modal_sheet_wrapper.dart';
import 'components/app_sheet_content_metadata_provider.dart';

Future<T?> appShowModularSheet<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  required TextStyle titleStyle,
  double headerHeight = 68,
  double bottomGap = 50,
  double maxSheetFraction = 0.94,
  ui.ImageFilter? backgroundBlur,
  Color barrierColor = const Color(0x4D000000),
  Color modalBackgroundColor = AppColors.white,
}) {
  int? itemCountForHeight;
  double? rowHeight = 56;

  if (content is AppSheetContentMetadataProvider) {
    final meta = content as AppSheetContentMetadataProvider;
    itemCountForHeight = meta.estimatedRowCount;
    rowHeight = meta.estimatedRowHeight;
  }

  final initFraction =
      (itemCountForHeight != null)
          ? _calcFraction(
            context: context,
            itemCount: itemCountForHeight,
            headerHeight: headerHeight,
            rowHeight: rowHeight,
            gap: bottomGap,
            maxFraction: maxSheetFraction,
          )
          : maxSheetFraction;

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    barrierColor: AppColors.transparent,
    builder:
        (_) => AppModalSheetWrapper(
          initFraction: initFraction,
          maxFraction: maxSheetFraction,
          blur: backgroundBlur,
          barrier: barrierColor,
          child: Material(
            color: modalBackgroundColor,
            child: Column(
              children: [
                Container(
                  height: headerHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: titleStyle),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: AppColors.gray700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: content),
                SizedBox(
                  height: bottomGap + MediaQuery.of(context).viewPadding.bottom,
                ),
              ],
            ),
          ),
        ),
  );
}

// // Вспомогательная функция вычисления высоты
double _calcFraction({
  required BuildContext context,
  required int itemCount,
  required double headerHeight,
  required double rowHeight,
  required double gap,
  required double maxFraction,
}) {
  final bottomInset = MediaQuery.of(context).viewPadding.bottom;
  final totalHeight = headerHeight + gap + itemCount * rowHeight + bottomInset;
  final screenHeight = MediaQuery.of(context).size.height;
  return (totalHeight / screenHeight).clamp(0.0, maxFraction);
}
