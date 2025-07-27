part of 'app_file_grid_bloc.dart';

abstract class AppFileGridEvent extends Equatable {
  const AppFileGridEvent();

  @override
  List<Object?> get props => [];
}

class AddFile extends AppFileGridEvent {
  final AppFileGridItem file;
  const AddFile(this.file);

  @override
  List<Object?> get props => [file];
}

class AddFileWithPath extends AppFileGridEvent {
  final String name;
  final String extension;
  final int sizeBytes;
  final String? path;

  const AddFileWithPath({
    required this.name,
    required this.extension,
    required this.sizeBytes,
    required this.path,
  });

  @override
  List<Object?> get props => [name, extension, sizeBytes, path];
}

class RemoveFile extends AppFileGridEvent {
  final String name;
  const RemoveFile(this.name);

  @override
  List<Object?> get props => [name];
}

class UpdateFile extends AppFileGridEvent {
  final String name;
  final AppFileGridItem updated;
  const UpdateFile(this.name, this.updated);

  @override
  List<Object?> get props => [name, updated];
}

class RetryFile extends AppFileGridEvent {
  final String name;
  const RetryFile(this.name);

  @override
  List<Object?> get props => [name];
}
