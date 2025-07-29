class PagedResult<T> {
  final List<T> items;
  final int totalCount;
  final bool hasMore;

  const PagedResult({
    required this.items,
    required this.totalCount,
    required this.hasMore,
  });
}
