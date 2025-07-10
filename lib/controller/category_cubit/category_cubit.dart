import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_frame/models/response_models/category_model.dart';
import 'package:project_frame/repository/categories_repo.dart';
part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository categoryRepo;

  CategoryCubit({required this.categoryRepo}) : super(CategoryInitial());

  /// to get all the categories
  getAllCategories({required String languageCode}) async {

    emit(CategoryLoadingState());

    try {
      final result = await categoryRepo.getAllCategories(
        queryParams: {"language_code": languageCode},
      );

      result.fold(
        (error) => emit(CategoryErrorState(error: error)),
        (data) => emit(CategoryLoadedState(categoryList: data)),
      );

    } catch (e) {
      emit(CategoryErrorState(error: e.toString()));
    }
  }
}
