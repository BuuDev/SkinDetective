import 'package:json_annotation/json_annotation.dart';
part 'picture.g.dart';

@JsonSerializable()
class Picture {
  @JsonKey(name: 'path_test', ignore: true)
  late String? path;
  @JsonKey(name: 'id_test', ignore: true)
  late int? id;
  @JsonKey(name: 'data')
  late String? data;
  @JsonKey(name: 'status')
  late String? status;
  @JsonKey(name: 'code')
  late int? code;
  Picture({this.id, this.path, this.data, this.status, this.code});

  @override
  String toString() {
    return "PictureModel id $id path:$path data:$data";
  }

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);

  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
