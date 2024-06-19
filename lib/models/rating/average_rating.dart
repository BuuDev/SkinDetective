import 'package:json_annotation/json_annotation.dart';
part 'average_rating.g.dart';

@JsonSerializable()
class AverageRating {
  double averageRating;
  AverageRating({required this.averageRating});

  factory AverageRating.fromJson(Map<String, dynamic> json) =>
      _$AverageRatingFromJson(json);

  Map<String, dynamic> toJson() => _$AverageRatingToJson(this);
}
