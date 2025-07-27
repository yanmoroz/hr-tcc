part of 'app_file_grid_bloc.dart';

class AppFileGridState extends Equatable {
  final List<AppFileGridItem> files;
  final String? error;

  const AppFileGridState({this.files = const [], this.error});

  AppFileGridState copyWith({List<AppFileGridItem>? files, String? error}) {
    return AppFileGridState(files: files ?? this.files, error: error);
  }

  @override
  List<Object?> get props => [files, error];
}
