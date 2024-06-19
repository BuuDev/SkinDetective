import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/tips/tips.dart';
part 'tips_data.g.dart';

@JsonSerializable()
class TipsData {
  final List<Tips> data;

  TipsData({required this.data});

  factory TipsData.fromJson(Map<String, dynamic> json) =>
      _$TipsDataFromJson(json);

  Map<String, dynamic> toJson() => _$TipsDataToJson(this);
}
