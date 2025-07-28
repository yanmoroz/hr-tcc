import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class FilesAnswerWidget extends StatelessWidget {
  final List<AppFileGridItem> files;
  final ValueChanged<List<AppFileGridItem>> onFilesChanged;

  const FilesAnswerWidget({
    super.key,
    required this.files,
    required this.onFilesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppFileGrid(
      files: files,
      mode: AppFileGridMode.edit,
      onAddFile: () async {
        final result = await FilePicker.platform.pickFiles(withData: true);
        if (result != null && result.files.isNotEmpty) {
          final file = result.files.first;
          final extension = file.extension?.toLowerCase() ?? '';
          final isImage = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'heic',
            'bmp',
            'webp',
          ].contains(extension);
          final item = AppFileGridItem(
            name: file.name,
            extension: extension,
            sizeBytes: file.size,
            status: AppFileUploadStatus.success,
            previewImage:
                (isImage && file.path != null)
                    ? FileImage(File(file.path!))
                    : null,
            progress: 1.0,
          );
          onFilesChanged([...files, item]);
        }
      },
      onRemoveFile: (name) {
        onFilesChanged(files.where((f) => f.name != name).toList());
      },
    );
  }
}
