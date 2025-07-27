import 'package:flutter/material.dart';

import '../../../../models/resail_detail_booking_cell_model.dart';
import '../../../widgets/common/app_show_modular_sheet/components/app_sheet_content_metadata_provider.dart';
import 'resail_detail_booking_cell.dart';

class ResailDetailBookingListCell extends StatelessWidget
    implements AppSheetContentMetadataProvider {
  final List<ResailDetailBookingCellModel> items;

  const ResailDetailBookingListCell({super.key, required this.items});

  @override
  int get estimatedRowCount => items.length;

  @override
  double get estimatedRowHeight => 72;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ResailDetailBookingCell(model: items[index]);
      },
    );
  }
}
