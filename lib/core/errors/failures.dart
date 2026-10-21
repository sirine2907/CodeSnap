// Thrown by the data layer when something goes wrong with local storage.
class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

// What the repositories throw up to the blocs, so the UI can show a message.
class Failure implements Exception {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
