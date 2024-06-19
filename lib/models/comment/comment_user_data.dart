import 'package:json_annotation/json_annotation.dart';
part 'comment_user_data.g.dart';

@JsonSerializable()
class CommentUserData {
  int id;
  String name;
  String email;
  String? avatar;

  CommentUserData({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory CommentUserData.fromJson(Map<String, dynamic> json) =>
      _$CommentUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$CommentUserDataToJson(this);
}
