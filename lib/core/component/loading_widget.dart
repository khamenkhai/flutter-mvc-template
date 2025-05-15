import 'package:flutter/cupertino.dart';
import 'package:project_frame/core/utils/context_extension.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color, this.radius = 15});
  final Color? color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: color ?? context.primaryColor,
      radius: radius,
    );
  }
}
