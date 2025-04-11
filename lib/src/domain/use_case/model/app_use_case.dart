/// For use cases that don't require parameters
abstract class AppUseCaseWithRequest<T, R> {
  T run({required R request});
}

/// Generic UseCase interface that all use cases will implement
abstract class AppUseCase<T> {
  T run();
}
