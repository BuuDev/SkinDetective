import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/blog_save_user/blog_user_data.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/models/cosmetic_user/cosmetic_user_data.dart';
import 'package:skin_detective/models/create_post/create_post_data.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/services/api_client.dart';

part 'post.g.dart';

@RestApi()
abstract class PostService {
  factory PostService(Dio dio, {String baseUrl}) = _PostService;

  factory PostService.client({bool? isLoading}) {
    return PostService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @GET(RoutePathApi.postUser)
  Future<Pagination<ConsMeticData>> getPostUser(@Query('paginate') int paginate,
      @Query('page') int page, @Header('language') String language);

  @POST(RoutePathApi.createPost)
  @MultiPart()
  Future<CreatePostData> createPost(
      @Query("title") String title,
      @Query("status") String status,
      @Query("content") String content,
      @Query("agree") bool agreeTerm,
      [@Part(name: "images[]") List<File>? images]);

  @POST(RoutePathApi.updatePost)
  @MultiPart()
  Future<CreatePostData> updatePost(
      @Path('id') id,
      @Query("list_image_delete_id") String listDeleteImage,
      @Query("title") String title,
      @Query("content") String content,
      @Query("status") String status,
      [@Part(name: "images[]") List<File>? images]);

  @GET(RoutePathApi.postUserDetail)
  Future<CreatePostData> getPostUserDetail(@Path('id') id,
      @Query('type') String type, @Header('language') String language);

  @GET(RoutePathApi.getSaveCosmetic)
  Future<Pagination<CosmeticUserData>> getCosmeticUser(
      @Query('paginate') int paginate,
      @Query('page') int page,
      @Query('type') String type,
      @Header('language') String language);

  @GET(RoutePathApi.getSaveBlog)
  Future<Pagination<BlogUserData>> getBlogUser(
      @Query('paginate') int paginate,
      @Query('page') int page,
      @Query('type') String type,
      @Header('language') String language);
}
