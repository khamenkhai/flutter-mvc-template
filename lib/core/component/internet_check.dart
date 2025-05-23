import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_frame/controller/internet_cubit/internet_connection_cubit.dart';
import 'package:project_frame/core/component/internet_error.dart';
import 'package:project_frame/core/component/loading_widget.dart';

class ConnectionAwareWidget extends StatelessWidget {
  const ConnectionAwareWidget({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetConnectionCubit, InternetConnectionState>(
      listener: (context, state) {
        if (state is InternetConnectedState) {
          onRefresh();
        }
      },
      builder: (context, state) {
        if (state is InternetConnectedState) {
          return child;
        } else if (state is InternetDisconnectedState) {
          return Center(child: InternetErrorWidget(onRetry: onRefresh));
        } else if (state is InternetLoadingState) {
          return const LoadingWidget();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
