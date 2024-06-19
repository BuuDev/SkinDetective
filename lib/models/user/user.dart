import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'username')
  String? userName;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'avatar')
  String? avatar;

  @JsonKey(name: 'birthday')
  int? birthday;

  @JsonKey(name: 'nationality_id')
  int? nationalityId;

  @JsonKey(name: 'role_id')
  int rolId;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'updated_at')
  String? updatedAt;

  @JsonKey(name: 'deleted_at')
  String? deletedAt;

  @JsonKey(name: 'active')
  int active;

  User({
    required this.id,
    required this.name,
    this.userName,
    required this.email,
    this.avatar,
    this.birthday,
    this.nationalityId,
    required this.rolId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.active,
  });

  static get userEmpty {
    return User(id: 0, name: '', email: '', rolId: 0, active: 0);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}



