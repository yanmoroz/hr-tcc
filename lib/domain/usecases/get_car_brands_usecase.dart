import '../repositories/car_brand_repository.dart';

class GetCarBrandsUseCase {
  final CarBrandRepository repository;
  GetCarBrandsUseCase(this.repository);

  Future<List<String>> call() => repository.getCarBrands();
}
