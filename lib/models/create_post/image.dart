import 'package:json_annotation/json_annotation.dart';
part 'image.g.dart';

@JsonSerializable()
class Images {
  int id;
  String? url;
  String? type;
  String? name;
  @JsonKey(name: 'post_id')
  int postId;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;

  Images({
    required this.id,
    this.url,
    this.type,
    this.name,
    required this.postId,
    this.createdAt,
    this.updatedAt,
  });

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}
