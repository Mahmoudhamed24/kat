class DataChaiy {
  late String title;
  late String message;
  late String phone;
  
  DataChaiy.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      title = json['title'] ?? '';
      message = json['message'] ?? '';
      phone = json['phone'] ?? '';
    } else {
      title = '';
      message = '';
      phone = '';
    }
  }
}