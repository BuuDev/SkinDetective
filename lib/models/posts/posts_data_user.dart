import 'package:json_annotation/json_annotation.dart';
part 'posts_data_user.g.dart';

@JsonSerializable()
class PostsDataUser {
  String name;

  PostsDataUser({required this.name});

  factory PostsDataUser.fromJson(Map<String, dynamic> json) =>
      _$PostsDataUserFromJson(json);

  Map<String, dynamic> toJson() => _$PostsDataUserToJson(this);
}
