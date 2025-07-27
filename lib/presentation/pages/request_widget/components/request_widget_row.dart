import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/request_widget_item_model.dart';

class RequestWidgetRow extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const RequestWidgetRow({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 24, height: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTypography.text2Medium)),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.gray700,
          ),
        ],
      ),
    );
  }

  static List<Widget> buildRowsFactory(
    List<RequestWidgetItemModel> items, {
    required VoidCallback Function(int index, RequestWidgetItemModel item)
    onTapBuilder,
  }) {
    const double padding = 11;
    return [
      for (int i = 0; i < items.length; i++) ...[
        Padding(
          padding: EdgeInsets.only(
            top: i == 0 ? 0 : padding,
            bottom: i == items.length - 1 ? 0 : padding,
          ),
          child: RequestWidgetRow(
            iconPath: items[i].iconPath,
            title: items[i].title,
            onTap: onTapBuilder(i, items[i]),
          ),
        ),
        if (i < items.length - 1)
          const Divider(height: 1, color: AppColors.gray200),
      ],
    ];
  }
}
