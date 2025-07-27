import 'package:hr_tcc/domain/repositories/car_brand_repository.dart';

class CarBrandRepositoryMock implements CarBrandRepository {
  @override
  Future<List<String>> getCarBrands() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      'Audi',
      'BMW',
      'Belgee',
      'Changan',
      'Chery',
      'Chevrolet',
      'Ford',
      'Geely',
      'Haval',
      'Hyundai',
      'Kia',
    ];
  }
}
