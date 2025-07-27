class NameHelper {
  // Получает инициалы из полного имени
  static String getInitials(String senderName) {
    final parts = senderName.trim().split(' ').where((p) => p.isNotEmpty).toList();

    if (parts.isEmpty) {
      return '';
    }

    if (parts.length == 1) {
      final word = parts.first;
      return word.substring(0, word.length > 1 ? 2 : 1).toUpperCase();
    }

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
