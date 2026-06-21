Future<void> runInParallel(List<Future<void> Function()> tasks, int chunkSize) async {
  for (int i = 0; i < tasks.length; i += chunkSize) {
    final chunk = tasks.sublist(
      i,
      i + chunkSize > tasks.length ? tasks.length : i + chunkSize,
    );
    await Future.wait(chunk.map((lambda) => lambda()));
  }
}