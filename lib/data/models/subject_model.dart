import 'dart:convert';

Subject subjectFromJson(String str) => Subject.fromJson(json.decode(str));

String subjectToJson(Subject data) => json.encode(data.toJson());

class Subject {
  final String id;
  final String name;
  final String user;
  final String userName;
  Subject({
    required this.id,
    required this.name,
    required this.user,
    required this.userName,
  });

  Subject copyWith({
    String? id,
    String? name,
    String? user,
    String? userName,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      user: user ?? this.user,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user': user,
      'userName': userName,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      user: map['user'] ?? '',
      userName: map['userName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Subject(id: $id, name: $name, user: $user, userName: $userName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subject &&
        other.id == id &&
        other.name == name &&
        other.user == user &&
        other.userName == userName;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ user.hashCode ^ userName.hashCode;
  }
}
