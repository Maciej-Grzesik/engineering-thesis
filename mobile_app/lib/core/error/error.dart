class Failure {
  final String message;

  Failure([this.message = 'An unexpected error occurred.']);

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
