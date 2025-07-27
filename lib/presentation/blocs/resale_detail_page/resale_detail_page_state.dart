part of 'resale_detail_page_bloc.dart';

class ResaleDetailPageState {
  final List<String> imagePaths;
  final List<ResailDetailBookingCellModel> bookingsHistory;
  final bool isLocked;
  final String price;
  final String title;
  final String? fileName;
  final String? fileURL;
  final int messagesCount;
  final List<(String, String)> details;
  final String lastStatusChangeText;

  ResaleDetailPageState({
    required this.imagePaths,
    required this.bookingsHistory,
    required this.isLocked,
    required this.price,
    required this.title,
    this.fileName,
    this.fileURL,
    required this.messagesCount,
    required this.details,
    required this.lastStatusChangeText,
  });

  ResaleDetailPageState copyWith({
    List<String>? imagePaths,
    List<ResailDetailBookingCellModel>? bookingsHistory,
    bool? isLocked,
    String? price,
    String? title,
    String? fileName,
    String? fileURL,
    int? messagesCount,
    List<(String, String)>? details,
    String? lastStatusChangeText,
  }) {
    return ResaleDetailPageState(
      imagePaths: imagePaths ?? this.imagePaths,
      bookingsHistory: bookingsHistory ?? this.bookingsHistory,
      isLocked: isLocked ?? this.isLocked,
      price: price ?? this.price,
      title: title ?? this.title,
      fileName: fileName ?? this.fileName,
      fileURL: fileURL ?? this.fileURL,
      messagesCount: messagesCount ?? this.messagesCount,
      details: details ?? this.details,
      lastStatusChangeText: lastStatusChangeText ?? this.lastStatusChangeText,
    );
  }

  factory ResaleDetailPageState.initial() {
    return ResaleDetailPageState(
      imagePaths: [],
      bookingsHistory: [],
      isLocked: false,
      price: '',
      title: '',
      fileName: '',
      messagesCount: 0,
      details: [],
      lastStatusChangeText: '',
    );
  }
}