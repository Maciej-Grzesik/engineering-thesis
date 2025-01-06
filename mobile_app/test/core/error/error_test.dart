import 'package:mobile_app/core/error/error.dart';
import 'package:test/test.dart';

void main() {
  group('Failure', () {
    test('default constructor sets default message', () {
      final failure = Failure();
      expect(failure.message, 'An unexpected error occurred.');
    });

    test('constructor sets custom message', () {
      const customMessage = 'Custom error message';
      final failure = Failure(customMessage);
      expect(failure.message, customMessage);
    });

    test('equality operator returns true for same messages', () {
      const message = 'Error occurred';
      final failure1 = Failure(message);
      final failure2 = Failure(message);
      expect(failure1, equals(failure2));
    });

    test('equality operator returns false for different messages', () {
      final failure1 = Failure('Error 1');
      final failure2 = Failure('Error 2');
      expect(failure1, isNot(equals(failure2)));
    });

    test('hashCode is consistent with message', () {
      const message = 'Error occurred';
      final failure = Failure(message);
      expect(failure.hashCode, message.hashCode);
    });

    test('toString returns the message', () {
      const message = 'Error occurred';
      final failure = Failure(message);
      expect(failure.toString(), message);
    });
  });
}
