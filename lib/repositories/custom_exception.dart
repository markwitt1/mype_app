import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomException implements Exception {
  final String? message;
  const CustomException({this.message = 'Something went wrong!'});

  @override
  String toString() => 'CustomException {message: $message }';
}

final exceptionProvider = StateProvider<CustomException?>((ref) => null);
