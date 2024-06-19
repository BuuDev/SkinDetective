import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/comment/comment_data.dart';
part 'comment.g.dart';

@JsonSerializable()
class Comment {
  List<CommentData> data;

  Comment({required this.data});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
