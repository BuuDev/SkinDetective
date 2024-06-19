import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/comment/comment.dart';
import 'package:skin_detective/services/api_client.dart';

part 'comment.g.dart';

@RestApi()
abstract class CommentService {
  factory CommentService(Dio dio, {String baseUrl}) = _CommentService;

  factory CommentService.client({bool? isLoading}) {
    return CommentService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @POST(RoutePathApi.comments)
  Future<Comment> getComment(@Path('id') id);

  @POST(RoutePathApi.deleteComment)
  Future<void> deleteComment(@Path('id') id);

  @POST(RoutePathApi.createComment)
  Future<void> createdComment(
      @Query('post_id') int postId, @Query('content') String content);
}
