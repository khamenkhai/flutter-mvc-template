import 'package:project_frame/core/const/api_const.dart';
import 'package:project_frame/core/network/dio_client.dart';
import 'package:project_frame/core/utils/custom_logger.dart';
import 'package:project_frame/models/response_models/post_model.dart';
import 'package:fpdart/fpdart.dart';

class PostRepository {

  final DioClient dio;

  final CustomLogger logService;

  PostRepository({required this.dio, required this.logService});

  /// Helper method for handling POST requests
  Future<Either<String, PostModel>> _postRequest({
    required String apiUrl,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await dio.postRequest(
        apiUrl: apiUrl,
        requestBody: requestBody,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        PostModel post = PostModel.fromMap(response.data);
        return Right(post); // Return success in Right
      } else {
        return Left("${response.data["message"] ?? "Unknown error"}");
      }
    } catch (e) {
      logService.log(
        "Error log : $e",
      );
      return Left(e.toString()); // Return error in Left
    }
  }

  /// Helper method for handling GET requests
  Future<Either<String, PostModel>> _getRequest({
    required String apiUrl,
  }) async {
    try {
      final response = await dio.getRequest(apiUrl: apiUrl);
      if (response.statusCode == 200 || response.statusCode == 201) {
        PostModel post = PostModel.fromMap(response.data);
        return Right(post); 
      } else {
        return Left("${response.data["message"] ?? "Unknown error"}");
      }
    } catch (e) {
      logService.log(
        "Error log : $e",
      );
      return Left("Error: ${e.toString()}"); // Return error in Left
    }
  }

  /// Helper method for handling PUT requests
  Future<Either<String, PostModel>> _putRequest({
    required String apiUrl,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await dio.putRequest(
        apiUrl: apiUrl,
        requestBody: requestBody,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        PostModel post = PostModel.fromMap(response.data);
        return Right(post); // Return success in Right
      } else {
        return Left("${response.data["message"] ?? "Unknown error"}");
      }
    } catch (e) {
      logService.log(
        "Error log : $e",
      );
      return Left(e.toString()); // Return error in Left
    }
  }

  /// Helper method for handling DELETE requests
  Future<Either<String, PostModel>> _deleteRequest({
    required String apiUrl,
  }) async {
    try {
      final response = await dio.deleteRequest(apiUrl: apiUrl, requestBody: {});
      if (response.statusCode == 200 || response.statusCode == 201) {
        PostModel post = PostModel.fromMap(response.data);
        return Right(post); // Return success in Right
      } else {
        return Left("${response.data["message"] ?? "Unknown error"}");
      }
    } catch (e) {
      logService.log(
        "Error log : $e",
      );
      return Left(e.toString()); // Return error in Left
    }
  }

  /// Create a new post
  Future<Either<String, PostModel>> createPost({
    required Map<String, dynamic> requestBody,
  }) async {
    return await _postRequest(
      apiUrl: ApiConstants.CREATE_POST,
      requestBody: requestBody,
    );
  }

  /// Fetch a post by ID
  Future<Either<String, PostModel>> getPostById({
    required String postId,
  }) async {
    return await _getRequest(
      apiUrl: "${ApiConstants.GET_POST_BY_ID}/$postId",
    );
  }

  /// Fetch all posts
  Future<Either<String, PostModel>> getAllPosts() async {
    return await _getRequest(
      apiUrl: ApiConstants.GET_ALL_POSTS,
    );
  }

  /// Update a post
  Future<Either<String, PostModel>> updatePost({
    required String postId,
    required Map<String, dynamic> requestBody,
  }) async {
    return await _putRequest(
      apiUrl: "${ApiConstants.UPDATE_POST}/$postId",
      requestBody: requestBody,
    );
  }

  /// Delete a post
  Future<Either<String, PostModel>> deletePost({
    required String postId,
  }) async {
    return await _deleteRequest(
      apiUrl: "${ApiConstants.DELETE_POST}/$postId",
    );
  }
}