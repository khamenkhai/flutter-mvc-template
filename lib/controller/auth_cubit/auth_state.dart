import 'package:flutter/material.dart';
import 'package:project_frame/models/response_models/user_model.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessState extends AuthState {
  final UserModel user;
  AuthSuccessState({required this.user});
}

final class AuthLogoutState extends AuthState {}
