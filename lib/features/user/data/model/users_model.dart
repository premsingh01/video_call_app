import 'package:video_call_app/features/user/domain/entity/users_entity.dart';

class UsersModel extends UsersEntity {
  UsersModel({required super.id, required super.name, required super.avatar});

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    final fullName = "${json['first_name'] ?? ''} ${json['last_name'] ?? ''}";
    return UsersModel(
      id: json['id'],
      name: fullName,
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'avatar': avatar,
      };

  factory UsersModel.fromMap(Map<String, dynamic> map) => UsersModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        avatar: map['avatar'] ?? '',
      );
}
