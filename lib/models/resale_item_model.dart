import 'package:hr_tcc/models/models.dart';

class ResaleItemModel {
  final String id;
  final String imageUrl;
  final String price;
  final String title;
  final String type;
  final SaleStatus status;
  final String authorName;
  final DateTime createdAt;

  const ResaleItemModel({
    required this.id,
    required this.imageUrl,
    required this.price,
    required this.type,
    required this.title,
    required this.status,
    required this.authorName,
    required this.createdAt,
  });

  factory ResaleItemModel.fromJson(Map<String, dynamic> json) {
    return ResaleItemModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      price: json['price'] as String,
      type: json['type'] as String,
      title: json['description'] as String,
      status: _statusFromString(json['status'] as String),
      authorName: json['authorName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static SaleStatus _statusFromString(String status) {
    switch (status) {
      case 'reserved':
        return SaleStatus.reserved;
      case 'onSale':
        return SaleStatus.onSale;
      case 'removedFromSale':
        return SaleStatus.removedFromSale;
      default:
        return SaleStatus.removedFromSale;
    }
  }

  ResaleItemModel copyWith({
    String? id,
    String? imageUrl,
    String? price,
    String? title,
    String? type,
    SaleStatus? status,
    String? authorName,
    DateTime? createdAt,
  }) {
    return ResaleItemModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
