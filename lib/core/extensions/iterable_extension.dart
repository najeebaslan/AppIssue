//iterableExtension
extension IterableChecker on Iterable? {
  /// Checks if the iterable is null or empty.
  bool get isEmptyOrNull => this?.isEmpty ?? true;

  /// Gets the first element of the iterable, or null if it's empty or null.
  T? firstOrNull<T>() {
    if (this == null || this?.isEmpty == true) {
      return null;
    } else {
      return this!.first as T; // Cast to the desired type (T)
    }
  }
}
