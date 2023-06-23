class DataModel {
  late String message;
  DataModel.fromJson(Map<String, dynamic>? json) {
    message = json!['message'];
  }
}
