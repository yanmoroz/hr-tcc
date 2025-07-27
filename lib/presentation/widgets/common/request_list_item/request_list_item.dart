import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/entities/entities.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';

class RequestListItem extends StatelessWidget {
  final Request request;
  final VoidCallback? onTap;
  const RequestListItem({required this.request, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A38990D), // #0A38990D - 5% opacity
            offset: Offset(0, 4), // смещение x=0, y=4
            blurRadius: 30, // размытие 30
          ),
        ],
      ),
      child: Card(
        color: Colors.transparent, // чтобы не перекрывать тень контейнера
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          leading: SvgPicture.asset(
            request.type.icon,
            width: 28,
            height: 28,
            placeholderBuilder: (ctx) => const Icon(Icons.description),
            colorFilter: const ColorFilter.mode(
              AppColors.black,
              BlendMode.srcIn,
            ),
          ),
          title: Text(
            request.type.name,
            style: AppTypography.text2Semibold.copyWith(color: AppColors.black),
          ),
          subtitle: Text(
            'от ${request.createdAt.day.toString().padLeft(2, '0')}.${request.createdAt.month.toString().padLeft(2, '0')}.${request.createdAt.year}',
            style: AppTypography.caption2Medium.copyWith(
              color: AppColors.gray700,
            ),
          ),
          trailing: StatusChip(status: request.status),
          onTap: onTap,
        ),
      ),
    );
  }
}
