import 'package:fpdart/fpdart.dart';
import 'package:project_frame/core/const/api_const.dart';
import 'package:project_frame/core/network/dio_client.dart';
import 'package:project_frame/core/utils/custom_logger.dart';
import 'package:project_frame/models/response_models/product_model.dart';

class ProductsRepo {
  final DioClient dioClient;
  final CustomLogger logger;

  ProductsRepo({
    required this.dioClient,
    required this.logger,
  });

  /// Get products by category (POST)
  Future<Either<String, List<ProductModel>>> getProductsByCategory({
    required int categoryId,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await dioClient.postRequest(
        apiUrl: "${ApiConst.productsByCategory}/$categoryId",
        requestBody: requestBody,
      );

      if (response.statusCode == 200) {
        var dataList = response.data as List;
        return Right(dataList.map((e) => ProductModel.fromJson(e)).toList());
      } else {
        return Left(response.data["message"] ?? "Failed to load products");
      }
    } catch (e) {
      logger.log(
        "ProductsRepo : getProductsByCategory': $e",
      );
      return Left("Something went wrong: $e");
    }
  }

  /// Get all products (GET)
  Future<Either<String, List<ProductModel>>> getAllProducts({
    required Map<String, String> queryParams,
  }) async {
    try {
      final response = await dioClient.getRequest(
        apiUrl: ApiConst.allProducts,
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        var dataList = response.data as List;
        return Right(dataList.map((e) => ProductModel.fromJson(e)).toList());
      } else {
        return Left(response.data["message"] ?? "Failed to load products");
      }
    } catch (e) {
      logger.logWarning(
        "Error log : $e",
        error: 'ProductsRepo : getAllProducts',
      );
      return Left("Something went wrong: $e");
    }
  }
}
