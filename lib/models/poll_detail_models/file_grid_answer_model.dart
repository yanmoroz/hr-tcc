import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

class FileGridAnswerModel extends PollAnswerAbstractModel {
  final List<AppFileGridItem> files;

  const FileGridAnswerModel({required String questionId, this.files = const []})
    : super(questionId, PollAnswerType.fileGrid);

  factory FileGridAnswerModel.fromJson(Map<String, dynamic> json) =>
      FileGridAnswerModel(
        questionId: json['questionId'] as String,
        files:
            (json['files'] as List<dynamic>? ?? [])
                .map(
                  (e) => AppFileGridItem(
                    name: e['name'] as String,
                    extension: e['extension'] as String,
                    sizeBytes: e['sizeBytes'] as int,
                    status: AppFileUploadStatus.success,
                  ),
                )
                .toList(),
      );

  @override
  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'type': type.name,
    'files':
        files
            .map(
              (f) => {
                'name': f.name,
                'extension': f.extension,
                'sizeBytes': f.sizeBytes,
              },
            )
            .toList(),
  };
}
