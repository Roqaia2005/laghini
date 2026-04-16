import 'dart:convert';

class User {
  final String id;
  final String fullname;
  final String email;
  final bool isOnline;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    this.isOnline = false,
  });

  User copyWith({String? id, String? fullname, String? email, bool? isOnline}) {
    return User(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'isOnline': isOnline,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      fullname: map['fullname'] ?? '',
      email: map['email'] ?? '',
      isOnline: map['isOnline'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, fullname: $fullname, email: $email, isOnline: $isOnline)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.fullname == fullname &&
        other.email == email &&
        other.isOnline == isOnline;
  }

  @override
  int get hashCode {
    return id.hashCode ^ fullname.hashCode ^ email.hashCode ^ isOnline.hashCode;
  }
}
