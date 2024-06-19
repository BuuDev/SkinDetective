import 'package:json_annotation/json_annotation.dart';
part 'pagination.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Pagination<T> {
  int? total;

  int? perPage;

  int? currentPage;

  List<T> data;

  @JsonKey(ignore: true)
  bool isLoading = false;

  @JsonKey(ignore: true)
  bool isRefreshing = false;

  Pagination({
    required this.total,
    required this.currentPage,
    required this.data,
    required this.perPage,
  });

  factory Pagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PaginationFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$PaginationToJson<T>(this, toJsonT);

  factory Pagination.initial({int? perPage}) {
    return Pagination<T>(
        currentPage: 1, perPage: perPage ?? 1, total: 0, data: []);
  }

  bool get canLoadMore {
    ///Luc nay da full
    if (total != 0 && total == data.length || isLoading || isRefreshing) {
      return false;
    }

    return true;
  }

  Pagination<T> loadMore(Pagination<T> newData) {
    newData.data = [...data, ...newData.data];
    return newData;
  }

  Pagination<T> refresh(Pagination<T> newData) {
    return newData;
  }
}
