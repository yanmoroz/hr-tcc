import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class ResaleImageCarousel extends StatefulWidget {
  const ResaleImageCarousel({
    super.key,
    required this.imagePaths,
    this.aspectRatio = 16 / 9,
    this.borderRadius = 12,
  });
  final List<String> imagePaths; // Соотношение сторон карусели (16 : 9)
  final double aspectRatio;
  final double borderRadius;

  @override
  State<ResaleImageCarousel> createState() => _ResaleImageCarouselState();
}

class _ResaleImageCarouselState extends State<ResaleImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imagePaths.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: widget.imagePaths[index],
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  errorWidget:
                      (context, url, error) =>
                          const Icon(Icons.person, size: double.infinity),
                );
              },
            ),

            // Индикатор страницы
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_currentPage + 1} / ${widget.imagePaths.length}',
                    style: AppTypography.caption2Medium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
