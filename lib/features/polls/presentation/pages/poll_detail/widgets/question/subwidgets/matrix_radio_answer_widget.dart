import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class MatrixRadioAnswerWidget extends StatelessWidget {
  final List<String> rows;
  final List<String> columns;
  final Map<int, String?> values;
  final void Function(int rowIndex, String? columnValue) onChanged;

  static const double _questionColumnWidth = 120;
  static const double _optionColumnWidth = 30;
  static const double _optionPaddingVertical =
      8; // Отступ заголовка над радио кнопками
  static const double _rowPaddingVertical =
      12; // Отступ строки для радио кнопки

  const MatrixRadioAnswerWidget({
    super.key,
    required this.rows,
    required this.columns,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с названиями колонок
          Row(
            children: [
              const SizedBox(width: _questionColumnWidth),
              for (final col in columns)
                Container(
                  width: _optionColumnWidth,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: _optionPaddingVertical,
                  ),
                  child: Text(col, style: AppTypography.text2Regular),
                ),
            ],
          ),
          // Строки с подвопросами
          for (int r = 0; r < rows.length; r++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Подвопрос
                Container(
                  width: _questionColumnWidth,
                  padding: const EdgeInsets.symmetric(
                    vertical: _rowPaddingVertical,
                  ),
                  child: Text(rows[r], style: AppTypography.text1Regular),
                ),
                // Радиокнопки для каждой колонки
                for (final col in columns)
                  SizedBox(
                    width: _optionColumnWidth,
                    child: Radio<String>(
                      value: col,
                      groupValue: values[r],
                      onChanged: (v) => onChanged(r, v),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.blue700;
                        }
                        return AppColors.gray500;
                      }),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
