//const String apiKey = "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";
class Datatoken {
  late String message;
  Datatoken.fromJson(Map<String, dynamic>? json) {
    message = json!['apiKey'];
  }
}
