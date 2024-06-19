import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/blog_save_user/blog_user_data.dart';
part 'blog_user_response.g.dart';

@JsonSerializable()
class BlogUserResponse {
  int currentPage;
  List<BlogUserData> data;

  int perPage;
  int total;

  BlogUserResponse({
    required this.currentPage,
    required this.data,
    required this.perPage,
    required this.total,
  });

  factory BlogUserResponse.fromJson(Map<String, dynamic> json) =>
      _$BlogUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BlogUserResponseToJson(this);
}
