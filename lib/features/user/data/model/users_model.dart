import 'dart:convert';

import 'package:video_call_app/features/user/domain/entity/users_entity.dart';

class UsersModel extends UsersEntity {

    UsersModel({
        super.data,
    });

    factory UsersModel.fromRawJson(String str) => UsersModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        data: json["data"] == null ? [] : List<UserDetail>.from(json["data"]!.map((x) => UserDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    };
}

class UserDetail extends UserEntityDetail {

    UserDetail({
        super.id,
        super.email,
        super.firstName,
        super.lastName,
        super.avatar,
    });

    factory UserDetail.fromRawJson(String str) => UserDetail.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
    };
}

