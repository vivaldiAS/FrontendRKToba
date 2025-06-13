class Users {
  int? id;
  String? username;
  String? email;
  Null? emailVerifiedAt;
  String? password;
  Null? isAdmin;
  Null? isBanned;
  Null? rememberToken;
  String? createdAt;
  String? updatedAt;
  int? profileId;
  int? userId;
  String? name;
  String? noHp;
  String? birthday;
  String? gender;
  Null? deletedAt;

  Users(
      {this.id,
        this.username,
        this.email,
        this.emailVerifiedAt,
        this.password,
        this.isAdmin,
        this.isBanned,
        this.rememberToken,
        this.createdAt,
        this.updatedAt,
        this.profileId,
        this.userId,
        this.name,
        this.noHp,
        this.birthday,
        this.gender,
        this.deletedAt});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    isAdmin = json['is_admin'];
    isBanned = json['is_banned'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileId = json['profile_id'];
    userId = json['user_id'];
    name = json['name'];
    noHp = json['no_hp'];
    birthday = json['birthday'];
    gender = json['gender'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['password'] = this.password;
    data['is_admin'] = this.isAdmin;
    data['is_banned'] = this.isBanned;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_id'] = this.profileId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['no_hp'] = this.noHp;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}