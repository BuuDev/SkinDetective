import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/dataRating/data_rating.dart';
part 'response_rating.g.dart';

@JsonSerializable()
class ResponseRating {
  DataRating data;

  ResponseRating({required this.data});

  factory ResponseRating.fromJson(Map<String, dynamic> json) =>
      _$ResponseRatingFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseRatingToJson(this);
}
