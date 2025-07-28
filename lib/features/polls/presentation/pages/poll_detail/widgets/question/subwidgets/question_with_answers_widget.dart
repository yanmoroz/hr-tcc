import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class QuestionWithAnswersWidget extends StatelessWidget {
  final String? question;
  final List<Widget> answers;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final String? imageUrl;

  const QuestionWithAnswersWidget({
    super.key,
    this.question,
    required this.answers,
    this.padding,
    this.spacing = 8.0,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Вопрос
          if (question != null) ...[
            Text(question ?? '', style: AppTypography.title2Bold),
          ],
          const SizedBox(height: 12),
          // Картинка, если есть
          if (imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl ?? '',
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
            const SizedBox(height: 12),
          ],

          // Список ответов с отступами
          for (int i = 0; i < answers.length; i++) ...[
            answers[i],
            if (i < answers.length - 1) SizedBox(height: spacing),
          ],
        ],
      ),
    );
  }
}
