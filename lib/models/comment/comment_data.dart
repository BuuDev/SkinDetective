import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/comment/comment_user_data.dart';
part 'comment_data.g.dart';

@JsonSerializable()
class CommentData {
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'post_id')
  int postId;
  String status;
  String content;
  @JsonKey(name: 'created_at')
  String createdAt;
  CommentUserData users;

  CommentData({
    required this.id,
    required this.userId,
    required this.postId,
    required this.status,
    required this.content,
    required this.createdAt,
    required this.users,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDataToJson(this);
}
