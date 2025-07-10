import 'package:fpdart/fpdart.dart';
import 'package:project_frame/core/const/api_const.dart';
import 'package:project_frame/core/network/dio_client.dart';
import 'package:project_frame/core/utils/custom_logger.dart';
import 'package:project_frame/models/response_models/category_model.dart';

class CategoryRepository {

  final DioClient dioClient;
  final CustomLogger logger;
  
  CategoryRepository({required this.dioClient, required this.logger});

  /// get all categories list
  Future<Either<String, List<CategoryModel>>> getAllCategories({
    required Map<String, String> queryParams,
  }) async {
    try {
      final response = await dioClient.getRequest(
        apiUrl: ApiConst.CATEGORIES,
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        var dataList = response.data["data"] as List;
        return Right(dataList.map((e) => CategoryModel.fromMap(e)).toList());
      } else {
        return Left(response.data["message"] ?? "Failed to load categories");
      }
    } catch (e) {
      logger.log(
        "CategoryRepository : getAllCategories : $e",
      );
      throw Exception(e);
    }
  }
}
