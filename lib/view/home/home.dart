import 'package:flutter/material.dart';
import 'package:project_frame/core/component/scale_on_tap.dart';
import 'package:project_frame/core/const/app_colors.dart';
import 'package:project_frame/core/local_data/shared_prefs.dart';
import 'package:project_frame/core/utils/context_extension.dart';
import 'package:project_frame/core/utils/custom_logger.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  SharedPref sharedPref = GetIt.instance<SharedPref>();

  String value = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    value = await sharedPref.getString(key: "abc");
    setState(() {});
  }

  void _onRefresh() async {
    // Simulate a network call or data fetch
    await Future.delayed(const Duration(seconds: 3));

    // Complete the refresh
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Frame"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Testing"),
            ),
          ),
          Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: TextField(),
          ),
          Text(
            "Hello world",
            style: context.smallFont(),
          )
        ],
      ),
    );
  }

  // ignore: unused_element
  SmartRefresher _smartRefreshTesting() {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      header: ClassicHeader(
        refreshingIcon: LoadingAnimationWidget.threeRotatingDots(
          size: 24,
          color: AppColors.primary,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ScaleOnTap(
              onTap: () {
                CustomLogger logger = GetIt.instance<CustomLogger>();
                logger.log('message');
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                height: 300,
                color: Colors.red,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              height: 300,
              color: Colors.yellow,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              height: 300,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }


}
