part of '../filter_bar.dart';

class FilterBarTab extends StatelessWidget {
  final bool isSelected;
  final double borderRadius;
  final FilterTabModel tab;

  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const FilterBarTab({
    super.key,
    required this.isSelected,
    required this.tab,
    this.borderRadius = 24,
    this.selectedColor = AppColors.blue700,
    this.unselectedColor = AppColors.gray100,
    this.selectedTextColor = AppColors.white,
    this.unselectedTextColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : unselectedColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          Text(
            tab.label,
            style: AppTypography.text2Medium.copyWith(
              color: isSelected ? selectedTextColor : unselectedTextColor,
            ),
          ),
          if (tab.count !=
              null) // Для отображения числа рядом с названием фильера
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: AppColors.white,
                child: Text(
                  '${tab.count}',
                  style: AppTypography.caption3Semibold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
