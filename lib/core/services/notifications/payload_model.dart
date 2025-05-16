import 'dart:convert';

class PayloadModel {
  final String id;
  final String title;
  final String body;

  PayloadModel({
    required this.id,
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory PayloadModel.fromMap(Map<String, dynamic> map) {
    return PayloadModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PayloadModel.fromJson(String source) =>
      PayloadModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
