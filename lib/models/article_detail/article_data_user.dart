import 'package:json_annotation/json_annotation.dart';
part 'article_data_user.g.dart';

@JsonSerializable()
class ArticleDataUser {
  int id;
  String email;
  String name;
  String? avatar;

  ArticleDataUser(
      {required this.id,
      required this.email,
      required this.name,
      required this.avatar});

  factory ArticleDataUser.fromJson(Map<String, dynamic> json) =>
      _$ArticleDataUserFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDataUserToJson(this);
}
