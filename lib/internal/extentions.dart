extension CustomList<T> on List<T> {
  static T firstOrNull<T>(List<T> list) {
    if (list.isEmpty) {
      return null;
    } else {
      return list.first;
    }
  }
}
