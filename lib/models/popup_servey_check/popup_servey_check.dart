import 'package:json_annotation/json_annotation.dart';
part 'popup_servey_check.g.dart';

@JsonSerializable()
class PopupServeyCheck {
  @JsonKey(name: 'show_popup')
  bool showPopup;
  PopupServeyType? type;

  PopupServeyCheck({required this.showPopup, required this.type});

  factory PopupServeyCheck.fromJson(Map<String, dynamic> json) =>
      _$PopupServeyCheckFromJson(json);

  Map<String, dynamic> toJson() => _$PopupServeyCheckToJson(this);
}

enum PopupServeyType {
  @JsonValue('popupA')
  popupA,

  @JsonValue('popupB')
  popupB,
}
