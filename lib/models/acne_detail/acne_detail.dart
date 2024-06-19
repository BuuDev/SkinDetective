import 'package:json_annotation/json_annotation.dart';
part 'acne_detail.g.dart';

@JsonSerializable()
class AcneDetail {
  // @JsonKey(name: 'id')
  // late int id;
  @JsonKey(name: 'acne_box')
  late List<List<int>>? acneBox;
  @JsonKey(name: 'acne_box_class')
  late List<int>? acneBoxClass;
  @JsonKey(name: 'grading')
  late int? grading;

  @JsonKey(name: 'gradingDes', ignore: true)
  late String? gradingDes;

  AcneDetail({
    // required this.id,
    this.acneBox,
    this.acneBoxClass,
    this.grading,
    this.gradingDes,
  }) : super() {
    if (grading == 1) {
      gradingDes = "Bạn bị mụn một ít";
    } else if (grading == 2) {
      gradingDes = "Bạn bị mụn nhẹ";
    } else if (grading == 3) {
      gradingDes = "Bạn bị mụn trung bình";
    } else {
      gradingDes = "Bạn bị mụn nặng";
    }
  }

  @override
  String toString() {
    return "AcneDetail id  $acneBox  $grading";
  }

  factory AcneDetail.fromJson(Map<String, dynamic> json) =>
      _$AcneDetailFromJson(json);

  Map<String, dynamic> toJson() => _$AcneDetailToJson(this);
}
