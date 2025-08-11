import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_frame/controller/products_cubit/products_cubit.dart';
import 'package:project_frame/core/component/custom_cached_image.dart';
import 'package:project_frame/core/component/custom_error_widget.dart';
import 'package:project_frame/core/component/internet_check.dart';
import 'package:project_frame/core/service/local_noti_service.dart';
import 'package:project_frame/models/response_models/product_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocalNotificationService localNotificationService =
      LocalNotificationService();
  @override
  void initState() {
    context.read<ProductsCubit>().getAllProducts(isRefresh: false);

    localNotificationService.initializeLocalNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "FakeStore",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              localNotificationService
                  .showNotification(title: "title", body: "test", payload: {});
            },
          ),
          IconButton(
            icon:
                const Icon(Icons.shopping_bag_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/image-picker");
        },
        child: Icon(Icons.image),
      ),
      body: ConnectionAwareWidget(
        onRefresh: () {},
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoadingState) {
              return _buildSkeletonLoader();
            } else if (state is ProductsLoadedState) {
              return _buildProductGrid(state.products);
            } else if (state is ProductsErrorState) {
              return CustomErrorWidget(
                errorText: state.error,
                onRetry: () {
                  context
                      .read<ProductsCubit>()
                      .getAllProducts(isRefresh: false);
                },
              );
            } else {
              return CustomErrorWidget(errorText: "Something went wrong!");
            }
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    // Create a list of empty products for skeleton loading
    final skeletonProducts = List<ProductModel>.generate(
      6,
      (index) => ProductModel(
        id: 0,
        title: '',
        price: 0,
        description: '',
        category: '',
        image: '',
        rating: Rating(rate: 0, count: 0),
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: _buildProductGrid(skeletonProducts),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid columns
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);

        // Responsive padding based on screen width
        final horizontalPadding = _getHorizontalPadding(constraints.maxWidth);
        final cardPadding = _getCardPadding(constraints.maxWidth);

        // Responsive aspect ratio
        final aspectRatio = _getAspectRatio(constraints.maxWidth);

        return Container(
          margin: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: horizontalPadding,
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: aspectRatio,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _ProductCard(
                product: products[index],
                padding: cardPadding,
              );
            },
          ),
        );
      },
    );
  }

  // Helper methods for responsive values
  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth > 1600) return 6;
    if (screenWidth > 1200) return 5;
    if (screenWidth > 900) return 4;
    if (screenWidth > 600) return 3;
    return 2;
  }

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 1600) return 200;
    if (screenWidth > 1200) return 100;
    if (screenWidth > 900) return 60;
    if (screenWidth > 600) return 30;
    return 16;
  }

  double _getAspectRatio(double screenWidth) {
    if (screenWidth > 1600) return 0.85;
    if (screenWidth > 1200) return 0.8;
    if (screenWidth > 900) return 0.75;
    if (screenWidth > 600) return 0.7;
    return 0.65;
  }

  EdgeInsets _getCardPadding(double screenWidth) {
    if (screenWidth > 1600) return const EdgeInsets.all(20);
    if (screenWidth > 1200) return const EdgeInsets.all(16);
    if (screenWidth > 900) return const EdgeInsets.all(14);
    if (screenWidth > 600) return const EdgeInsets.all(12);
    return const EdgeInsets.all(10);
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final EdgeInsets padding;

  const _ProductCard({
    required this.product,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to product detail
        },
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Expanded(
                child: Center(
                  child: product.image.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )
                      : CustomNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.contain,
                          // errorBuilder: (context, error, stackTrace) =>
                          //     const Icon(
                          //   Icons.image_not_supported_outlined,
                          //   size: 48,
                          //   color: Colors.grey,
                          // ),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  product.category.isEmpty
                      ? ' '
                      : product.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Product title
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),

              // Price and rating row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.price == 0
                        ? ' '
                        : '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.rate == 0
                            ? ' '
                            : product.rating.rate.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
