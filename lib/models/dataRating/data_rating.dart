import 'package:json_annotation/json_annotation.dart';
part 'data_rating.g.dart';

@JsonSerializable()
class DataRating {
  int id;

  @JsonKey(name: 'user_id')
  int userId;

  DataRating({required this.id, required this.userId});

  factory DataRating.fromJson(Map<String, dynamic> json) =>
      _$DataRatingFromJson(json);

  Map<String, dynamic> toJson() => _$DataRatingToJson(this);
}
