import 'package:flutter/material.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/presentation/widgets/common/app_button/app_button.dart';

enum AppFileUploadStatus { idle, uploading, success, error }

enum AppFileGridMode { view, edit }

class AppFileGridItem {
  final String name;
  final String extension;
  final int sizeBytes;
  final AppFileUploadStatus status;
  final VoidCallback? onRemove;
  final VoidCallback? onRetry;
  final ImageProvider? previewImage;
  final double? progress;

  AppFileGridItem({
    required this.name,
    required this.extension,
    required this.sizeBytes,
    this.status = AppFileUploadStatus.idle,
    this.onRemove,
    this.onRetry,
    this.previewImage,
    this.progress,
  });

  AppFileGridItem copyWith({
    String? name,
    String? extension,
    int? sizeBytes,
    AppFileUploadStatus? status,
    VoidCallback? onRemove,
    VoidCallback? onRetry,
    ImageProvider? previewImage,
    double? progress,
  }) {
    return AppFileGridItem(
      name: name ?? this.name,
      extension: extension ?? this.extension,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      onRemove: onRemove ?? this.onRemove,
      onRetry: onRetry ?? this.onRetry,
      previewImage: previewImage ?? this.previewImage,
      progress: progress ?? this.progress,
    );
  }
}

class AppFileGrid extends StatelessWidget {
  final List<AppFileGridItem> files;
  final int columns;
  final String? title;
  final String? subtitle;
  final VoidCallback? onAddFile;
  final String addButtonText;
  final AppFileGridMode mode;
  final void Function(AppFileGridItem)? onOpenFile;
  final void Function(String)? onRemoveFile;
  final void Function(String)? onRetryFile;
  final void Function(String, AppFileGridItem)? onUpdateFile;

  const AppFileGrid({
    super.key,
    required this.files,
    this.columns = 3,
    this.title,
    this.subtitle,
    this.onAddFile,
    this.addButtonText = 'Добавить файл',
    this.mode = AppFileGridMode.edit,
    this.onOpenFile,
    this.onRemoveFile,
    this.onRetryFile,
    this.onUpdateFile,
  });

  @override
  Widget build(BuildContext context) {
    final items = List<Widget>.from(
      files.map(
        (file) => _FileGridCell(
          item: file,
          mode: mode,
          onOpenFile: onOpenFile,
          onRemoveFile: onRemoveFile,
          onRetryFile: onRetryFile,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null || subtitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: AppTypography.text1Medium.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      subtitle!,
                      style: AppTypography.text2Regular.copyWith(
                        color: AppColors.gray700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (items.isEmpty == false)
          GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.7,
            children: items,
          ),
        if (mode == AppFileGridMode.edit) ...[
          const SizedBox(height: 24),
          if (onAddFile != null)
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppButton(
                  text: addButtonText,
                  onPressed: onAddFile,
                  variant: AppButtonVariant.secondary,
                  isFullWidth: true,
                  icon: Icons.add,
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _FileGridCell extends StatelessWidget {
  final AppFileGridItem item;
  final AppFileGridMode mode;
  final void Function(AppFileGridItem)? onOpenFile;
  final void Function(String)? onRemoveFile;
  final void Function(String)? onRetryFile;

  const _FileGridCell({
    required this.item,
    required this.mode,
    this.onOpenFile,
    this.onRemoveFile,
    this.onRetryFile,
  });

  // === UI constants ===
  static final TextStyle extTextStyle = AppTypography.title3Bold.copyWith(
    color: accentColor,
  );
  static final TextStyle badgeTextStyle = AppTypography.caption3Medium.copyWith(
    color: Colors.white,
  );
  static final TextStyle nameTextStyle = AppTypography.text2Regular.copyWith(
    color: AppColors.gray700,
  );
  static const Color accentColor = AppColors.blue700;
  static const double side = 120;
  static const double borderRadius = 8;
  static const double checkCircleSize = 34;
  static const double checkIconSize = 24;
  static const double uploadingCircleSize = 34;
  static const double uploadingIndicatorSize = 26;
  static const double uploadingIconSize = 16;
  static const double removeButtonArea = 36;
  static const double removeButtonCircle = 20;
  static const double removeButtonIcon = 12;
  static const double fileSizeBadgeRadius = 8;
  static const double fileSizeBadgePaddingH = 10;
  static const double fileSizeBadgePaddingV = 4;
  static const double nameSpacing = 12;
  static const double fileSizeBadgeLeft = 12;
  static const double fileSizeBadgeBottom = 12;
  static const double removeButtonTop = 4;
  static const double removeButtonRight = 4;
  static const Color borderColor = AppColors.gray200;
  static const Color bgColor = AppColors.gray100;

  @override
  Widget build(BuildContext context) {
    final isImage = item.previewImage != null;
    final isSuccess = item.status == AppFileUploadStatus.success;
    return GestureDetector(
      onTap:
          mode == AppFileGridMode.view && onOpenFile != null
              ? () => onOpenFile!(item)
              : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: side,
                height: side,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: borderColor),
                ),
                child:
                    isImage
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(borderRadius),
                          child: Image(
                            image: item.previewImage!,
                            width: side,
                            height: side,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Center(
                          child: Text(
                            item.extension.toUpperCase(),
                            style: extTextStyle,
                          ),
                        ),
              ),
              // Галочка поверх превью для успешных изображений (только в режиме edit)
              if (isImage && isSuccess && mode == AppFileGridMode.edit)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: checkCircleSize,
                      height: checkCircleSize,
                      decoration: const BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: checkIconSize,
                      ),
                    ),
                  ),
                ),
              // Индикация загрузки с возможностью отмены
              if (item.status == AppFileUploadStatus.uploading)
                Positioned.fill(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap:
                              onRemoveFile != null
                                  ? () => onRemoveFile!(item.name)
                                  : null,
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            width: uploadingCircleSize,
                            height: uploadingCircleSize,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.white,
                              size: uploadingIconSize,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: uploadingIndicatorSize,
                          height: uploadingIndicatorSize,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end: item.progress ?? 0.0,
                            ),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return CircularProgressIndicator(
                                strokeWidth: 2,
                                value: value,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  accentColor,
                                ),
                                backgroundColor: borderColor,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Крестик (только в режиме edit, увеличенная область нажатия)
              if (mode == AppFileGridMode.edit)
                Positioned(
                  top: removeButtonTop,
                  right: removeButtonRight,
                  child: GestureDetector(
                    onTap:
                        onRemoveFile != null
                            ? () => onRemoveFile!(item.name)
                            : null,
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: removeButtonArea,
                      height: removeButtonArea,
                      alignment: Alignment.topRight,
                      child: Container(
                        width: removeButtonCircle,
                        height: removeButtonCircle,
                        decoration: const BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: removeButtonIcon,
                        ),
                      ),
                    ),
                  ),
                ),
              // Размер файла (только если не изображение)
              if (!isImage)
                Positioned(
                  left: fileSizeBadgeLeft,
                  bottom: fileSizeBadgeBottom,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: fileSizeBadgePaddingH,
                      vertical: fileSizeBadgePaddingV,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(fileSizeBadgeRadius),
                    ),
                    child: Text(
                      _formatSize(item.sizeBytes),
                      style: badgeTextStyle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: nameSpacing),
          Text(
            item.name,
            style: nameTextStyle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} Мб';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} Кб';
    } else {
      return '$bytes Б';
    }
  }
}
