import 'package:json_annotation/json_annotation.dart';
part 'post.g.dart';

@JsonSerializable()
class Post {
  @JsonKey(name: 'id')
  late int id;
  @JsonKey(name: 'image')
  late String image;
  @JsonKey(name: 'title')
  late String title;
  @JsonKey(name: 'date')
  late String date;

  Post({
    required this.id,
    required this.image,
    required this.date,
    required this.title,
  });

  @override
  String toString() {
    return "PostModel id $id ";
  }

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
