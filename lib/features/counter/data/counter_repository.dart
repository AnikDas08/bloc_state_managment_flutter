class CounterRepository {
  // Simulate an API call or local DB operation
  Future<int> fetchInitialCounter() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 0;
  }
}
