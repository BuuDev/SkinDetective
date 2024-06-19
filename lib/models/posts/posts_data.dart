import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/posts/posts.dart';
part 'posts_data.g.dart';

@JsonSerializable()
class PostData {
  List<Posts> data;
  int currentPage;
  int perPage;
  int total;
  

  PostData(
      {required this.data,
      required this.currentPage,
      required this.perPage,
      required this.total,
      });

  factory PostData.fromJson(Map<String, dynamic> json) =>
      _$PostDataFromJson(json);

  Map<String, dynamic> toJson() => _$PostDataToJson(this);
}
