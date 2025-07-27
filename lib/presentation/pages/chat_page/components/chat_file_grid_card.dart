import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class ChatFileGridCard extends StatelessWidget {
  final AppFileGridItem item;
  final VoidCallback onRemove;
  const ChatFileGridCard({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final isImage = item.previewImage != null;
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray200, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    image: item.previewImage!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Center(
                  child: Text(
                    item.extension.toUpperCase(),
                    style: AppTypography.title3Bold.copyWith(
                      color: AppColors.blue700,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                item.name,
                style: AppTypography.caption2Medium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppColors.blue700,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}