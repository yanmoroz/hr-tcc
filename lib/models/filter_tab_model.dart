class FilterTabModel<T> {
  final String label;
  final T value;
  final int? count; // Для отображения числа рядом с названием фильера

  FilterTabModel({required this.label, this.count, required this.value});
}