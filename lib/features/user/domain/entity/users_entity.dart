class UsersEntity {
    List<UserEntityDetail>? data;

    UsersEntity({
        this.data,
    });
}

class UserEntityDetail {
    int? id;
    String? email;
    String? firstName;
    String? lastName;
    String? avatar;

    UserEntityDetail({
        this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.avatar,
    });
}

