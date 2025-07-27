import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/presentation/widgets/common/app_file_grid/app_file_grid.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'dart:io';

part 'app_file_grid_event.dart';
part 'app_file_grid_state.dart';

class AppFileGridBloc extends Bloc<AppFileGridEvent, AppFileGridState> {
  final int maxFileSizeMb;
  late final int maxFileSizeBytes;

  AppFileGridBloc({this.maxFileSizeMb = 4}) : super(const AppFileGridState()) {
    maxFileSizeBytes = maxFileSizeMb * 1024 * 1024;
    on<AddFileWithPath>(_onAddFileWithPath);
    on<RemoveFile>(_onRemoveFile);
    on<UpdateFile>(_onUpdateFile);
    on<RetryFile>(_onRetryFile);
    on<AddFile>(_onAddFile);
  }

  Future<void> _onAddFileWithPath(
    AddFileWithPath event,
    Emitter<AppFileGridState> emit,
  ) async {
    if (event.sizeBytes > maxFileSizeBytes) {
      emit(
        state.copyWith(
          error: 'Файл слишком большой (максимум $maxFileSizeMb Мб)',
        ),
      );
      return;
    }
    final isImage = _isImage(event.extension);
    ImageProvider? previewImage;
    if (isImage && event.path != null) {
      previewImage = FileImage(File(event.path!));
    }
    var item = AppFileGridItem(
      name: event.name,
      extension: event.extension,
      sizeBytes: event.sizeBytes,
      status: AppFileUploadStatus.uploading,
      previewImage: previewImage,
      progress: 0.0,
    );
    emit(state.copyWith(files: List.from(state.files)..add(item), error: null));
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      item = item.copyWith(progress: i / 10.0);
      _updateFileInternal(item, emit);
    }
    item = item.copyWith(status: AppFileUploadStatus.success, progress: 1.0);
    _updateFileInternal(item, emit);
  }

  void _updateFileInternal(
    AppFileGridItem item,
    Emitter<AppFileGridState> emit,
  ) {
    final files = List<AppFileGridItem>.from(state.files);
    final idx = files.indexWhere((f) => f.name == item.name);
    if (idx != -1) {
      files[idx] = item;
      emit(state.copyWith(files: files));
    }
  }

  void _onAddFile(AddFile event, Emitter<AppFileGridState> emit) {
    if (event.file.sizeBytes > maxFileSizeBytes) {
      emit(
        state.copyWith(
          error: 'Файл слишком большой (максимум $maxFileSizeMb Мб)',
        ),
      );
      return;
    }
    final extension = event.file.extension.toLowerCase();
    final isImage = _isImage(extension);
    final previewImage = isImage ? event.file.previewImage : null;
    final item = event.file.copyWith(previewImage: previewImage);
    emit(state.copyWith(files: List.from(state.files)..add(item), error: null));
  }

  void _onRemoveFile(RemoveFile event, Emitter<AppFileGridState> emit) {
    emit(
      state.copyWith(
        files: List.from(state.files)..removeWhere((f) => f.name == event.name),
      ),
    );
  }

  void _onUpdateFile(UpdateFile event, Emitter<AppFileGridState> emit) {
    final files = List<AppFileGridItem>.from(state.files);
    final idx = files.indexWhere((f) => f.name == event.name);
    if (idx != -1) {
      files[idx] = event.updated;
      emit(state.copyWith(files: files));
    }
  }

  void _onRetryFile(RetryFile event, Emitter<AppFileGridState> emit) {
    final files = List<AppFileGridItem>.from(state.files);
    final idx = files.indexWhere((f) => f.name == event.name);
    if (idx != -1) {
      files[idx] = files[idx].copyWith(status: AppFileUploadStatus.uploading);
      emit(state.copyWith(files: files));
    }
  }

  bool _isImage(String extension) {
    return [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'heic',
      'bmp',
      'webp',
    ].contains(extension);
  }
}
