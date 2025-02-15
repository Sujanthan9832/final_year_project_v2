class AnalyticsService {
  Future<Map<String, double>> getEmotionStats() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Dummy emotion data (in percentages)
    return {
      "Happy": 45.0,
      "Sad": 25.0,
      "Neutral": 20.0,
      "Angry": 10.0,
    };
  }
}
