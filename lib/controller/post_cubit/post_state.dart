import 'package:project_frame/models/response_models/post_model.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final PostModel post;
  PostLoaded(this.post);
}

class PostsLoaded extends PostState {
  final List<PostModel> posts;

  PostsLoaded(this.posts);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}
