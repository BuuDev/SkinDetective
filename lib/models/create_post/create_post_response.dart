import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/create_post/create_post_data.dart';
part 'create_post_response.g.dart';

@JsonSerializable()
class CreatePostResponse {
  CreatePostData data;
  CreatePostResponse({required this.data});

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostResponseToJson(this);
}
