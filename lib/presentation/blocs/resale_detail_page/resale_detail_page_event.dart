part of 'resale_detail_page_bloc.dart';

abstract class ResaleDetailPageEvent {}

class LoadResaleDetailPage extends ResaleDetailPageEvent {}

class ToggleLockResaleDetailPage extends ResaleDetailPageEvent {}

class OnTapResaleDownloadButton extends ResaleDetailPageEvent {
  final String fileURL;

  OnTapResaleDownloadButton({required this.fileURL});
}
