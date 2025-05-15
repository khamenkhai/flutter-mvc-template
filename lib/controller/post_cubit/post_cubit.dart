import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_frame/controller/post_cubit/post_state.dart';
import 'package:project_frame/repository/post_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;

  PostCubit({required this.postRepository}) : super(PostInitial());

  // Create a new post
  Future<void> createPost(Map<String, dynamic> requestBody) async {
    emit(PostLoading());
    final result = await postRepository.createPost(requestBody: requestBody);
    result.fold(
      (error) => emit(PostError(error)),
      (post) => emit(PostLoaded(post)),
    );
  }

  // Fetch a post by ID
  Future<void> getPostById(String postId) async {
    emit(PostLoading());
    final result = await postRepository.getPostById(postId: postId);
    result.fold(
      (error) => emit(PostError(error)),
      (post) => emit(PostLoaded(post)),
    );
  }

  // Fetch all posts
  Future<void> getAllPosts() async {
    emit(PostLoading());
    final result = await postRepository.getAllPosts();
    result.fold(
      (error) => emit(PostError(error)),
      (post) => emit(PostsLoaded([post])), // Assuming the API returns a single post, adjust accordingly
    );
  }

  // Update a post
  Future<void> updatePost(String postId, Map<String, dynamic> requestBody) async {
    emit(PostLoading());
    final result = await postRepository.updatePost(postId: postId, requestBody: requestBody);
    result.fold(
      (error) => emit(PostError(error)),
      (post) => emit(PostLoaded(post)),
    );
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    emit(PostLoading());
    final result = await postRepository.deletePost(postId: postId);
    result.fold(
      (error) => emit(PostError(error)),
      (post) => emit(PostLoaded(post)),
    );
  }
}