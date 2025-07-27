import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/models/models.dart';

class PollsDetailRadioGroup extends StatelessWidget {
  final List<PollDetailOptionModel> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  const PollsDetailRadioGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < options.length; i++) ...[
            _buildOption(options[i]),
            if (i < options.length - 1)
              const Divider(height: 1, thickness: 1, color: AppColors.white),
          ],
        ],
      ),
    );
  }

  Widget _buildOption(PollDetailOptionModel option) {
    return InkWell(
      onTap: () => onChanged(option.id),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              if (option.imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: option.imageUrl ?? '',
                    fit: BoxFit.cover,
                    width: 128,
                    height: 128,
                    placeholder:
                        (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.person, size: double.infinity),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (option.title != null)
                Expanded(
                  child: Text(option.title!, style: AppTypography.text1Regular),
                )
              else
                const Spacer(),
              Radio<String>(
                value: option.id,
                groupValue: value,
                onChanged: onChanged,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.blue700;
                  }
                  return AppColors.gray500;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
