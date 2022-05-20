import 'dart:convert';

class HttpException {
  String status;
  String message;
  HttpException(this.status, this.message);

  Map<String, dynamic> toMap() {
    return {
      'status': this.status,
      'message': this.message,
    };
  }

  static HttpException fromMap(Map<String, dynamic> map) {
    return HttpException(
      map['status'],
      map['message'],
    );
  }

  static HttpException fromJson(String j) => HttpException.fromMap(jsonDecode(j));
  static List<HttpException> fromJsonList(String j) {
    final parsed = jsonDecode(j).cast<Map<String, dynamic>>();
    return parsed.map<HttpException>((map) => HttpException.fromMap(map)).toList();
  }

  String toJson() => jsonEncode(toMap());
}
