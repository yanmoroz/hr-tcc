import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/models/models.dart';
import 'package:hr_tcc/domain/models/models.dart';

class ResaleRepositoryImp implements ResaleRepository {
  @override
  Future<ResaleItemsResponse> fetchResaleItems() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final now = DateTime.now();
    return ResaleItemsResponse(
      onSale: [
        ResaleItemModel(
          id: '1',
          imageUrl: 'https://placehold.co/600x400@2x.png',
          price: '2 500 000',
          title: 'Audi A1',
          type: 'Автомобиль',
          status: SaleStatus.onSale,
          authorName: 'Алексей Петров',
          createdAt: now.subtract(const Duration(hours: 5)),
        ),
        ResaleItemModel(
          id: '2',
          imageUrl: 'https://placehold.co/600x400@2x.png',
          price: '2 900 000',
          title: 'Audi A2',
          type: 'Автомобиль',
          status: SaleStatus.onSale,
          authorName: 'Алексей Петров',
          createdAt: now.subtract(const Duration(hours: 4)),
        ),
        ResaleItemModel(
          id: '3',
          imageUrl: 'https://placehold.co/600x400@2x.png',
          price: '2 200 000',
          title: 'Audi A3',
          type: 'Автомобиль',
          status: SaleStatus.onSale,
          authorName: 'Алексей Петров',
          createdAt: now.subtract(const Duration(hours: 4)),
        ),
      ],
      reserved: [
        ResaleItemModel(
          id: '4',
          imageUrl: 'https://placehold.co/600x400@2x.png',
          price: '1 900 000',
          title: 'Audi A4',
          type: 'Автомобиль',
          status: SaleStatus.reserved,
          authorName: 'Игнатьева Оксана',
          createdAt: now.subtract(const Duration(hours: 21)),
        ),
      ],
    );
  }
}
