class Counter {
  const Counter();

  Stream<int> countdown({required int seconds}) {
    return Stream.periodic(const Duration(seconds: 1), (s) => seconds - s - 1)
        .take(seconds);
  }
}
