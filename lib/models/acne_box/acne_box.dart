import 'package:json_annotation/json_annotation.dart';
part 'acne_box.g.dart';

@JsonSerializable()
class AcneBox {
  // @JsonKey(name: 'id')
  // late int id;
  @JsonKey(name: 'icon')
  late String icon;
  @JsonKey(name: 'name')
  late String name;
  @JsonKey(name: 'count')
  late int count;

  AcneBox(
      {
      // required this.id,
      required this.icon,
      required this.name,
      required this.count});

  @override
  String toString() {
    return "AcneBox id $name ";
  }

  factory AcneBox.fromJson(Map<String, dynamic> json) =>
      _$AcneBoxFromJson(json);

  Map<String, dynamic> toJson() => _$AcneBoxToJson(this);
}
