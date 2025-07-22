import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_frame/models/response_models/product_model.dart';
import 'package:project_frame/repository/products_repo.dart';
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo productRepo;

  ProductsCubit({required this.productRepo}) : super(ProductsInitial());

  /// get all products by category
  void getProductsByCategory({
    required Map<String, dynamic> requestBody,
    required bool isRefresh,
    required int categoryId,
  }) async {
    emit(ProductsLoadingState());

    try {
      final result = await productRepo.getProductsByCategory(
        categoryId: categoryId,
        requestBody: requestBody,
      );

      result.fold(
        (error) => emit(ProductsErrorState(error: error)),
        (products) => emit(ProductsLoadedState(products: products)),
      );
    } catch (e) {
      emit(ProductsErrorState(error: 'getProductsByCategory : $e'));
    }
  }

  /// get all products
  void getAllProducts({
    required bool isRefresh,
  }) async {
    emit(ProductsLoadingState());

    try {
      final result = await productRepo.getAllProducts(queryParams: {});

      result.fold(
        (error) => emit(ProductsErrorState(error: error)),
        (products) => emit(ProductsLoadedState(products: products)),
      );
    } catch (e) {
      emit(ProductsErrorState(error: 'getAllProducts : $e'));
    }
  }

  
  /// get all products
  void testError() async {
    emit(ProductsLoadingState());

    try {
      final result = await productRepo.getErrors();

      result.fold(
        (error) => emit(ProductsErrorState(error: error)),
        (products) => emit(ProductsLoadedState(products: products)),
      );
    } catch (e) {
      emit(ProductsErrorState(error: 'testError : $e'));
    }
  }
}
