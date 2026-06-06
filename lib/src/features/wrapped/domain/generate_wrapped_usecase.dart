import 'package:flutter_riverpod/flutter_riverpod.dart';

final generateWrappedUseCaseProvider = Provider<GenerateWrappedUseCase>((ref) {
  return GenerateWrappedUseCase();
});

class GenerateWrappedUseCase {
  Future<void> call() async {
    // Stub
  }
}
