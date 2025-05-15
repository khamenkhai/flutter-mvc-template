import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_frame/controller/auth_cubit/auth_state.dart';
import 'package:project_frame/core/local_data/shared_prefs.dart';
import 'package:project_frame/models/response_models/user_model.dart';
import 'package:project_frame/repository/auth_repo.dart';
import 'package:fpdart/fpdart.dart';

class AuthCubit extends Cubit<AuthState> {
  
  final AuthRepository authRepository;
  final SharedPref sharedPref;

  AuthCubit({required this.authRepository, required this.sharedPref})
      : super(AuthInitial());

  /// Login with account
  Future<bool> login({required Map<String, dynamic> requestBody}) async {
    emit(AuthLoadingState());

    try {
      final Either<String, UserResponseModel> result = await authRepository.login(requestBody: requestBody);

      return result.fold(
        (failure) {
          emit(AuthLogoutState());
          return false; // Failed login attempt
        },
        (userResponse) {
          sharedPref.setString(
            key: sharedPref.bearerToken,
            value: userResponse.user.token.toString(),
          );
          emit(AuthSuccessState(user: userResponse.user));
          return userResponse.user.id != null &&
              userResponse.user.token != null;
        },
      );
    } catch (e) {
      emit(AuthLogoutState());
      return false;
    }
  }

  /// Register account
  Future<bool> register({required Map<String, dynamic> requestBody}) async {
    emit(AuthLoadingState());

    try {
      final Either<String, UserResponseModel> result =
          await authRepository.register(requestBody: requestBody);

      return result.fold(
        (failure) {
          emit(AuthLogoutState());
          return false; // Failed registration
        },
        (userResponse) {
          sharedPref.setString(
            key: sharedPref.bearerToken,
            value: userResponse.user.token.toString(),
          );
          emit(AuthSuccessState(user: userResponse.user));
          return true; // Successful registration
        },
      );
    } catch (e) {
      emit(AuthLogoutState());
      return false;
    }
  }

  /// Logout account
  void logout(BuildContext context) async {
    emit(AuthLoadingState());

    try {
      final Either<String, UserResponseModel> result =
          await authRepository.logout();

      result.fold(
        (failure) {
          emit(AuthLogoutState());
        },
        (data) {
          if (data.status) {
            sharedPref.setString(key: sharedPref.bearerToken, value: "");
            emit(AuthLogoutState());
          }
        },
      );
    } catch (e) {
      emit(AuthLogoutState());
    }
  }

  /// Delete account
  void deleteAccount({
    required BuildContext context,
    required String userId,
  }) async {
    emit(AuthLoadingState());
    try {
      final Either<String, UserResponseModel> result =
          await authRepository.delete(userId: userId);

      result.fold(
        (failure) {
          emit(AuthLogoutState());
        },
        (data) {
          if (data.status) {
            sharedPref.setString(key: sharedPref.bearerToken, value: "");
            emit(AuthLogoutState());
          }
        },
      );
    } catch (e) {
      emit(AuthLogoutState());
    }
  }

  /// Check login status
  void checkLoginStatus() async {
    emit(AuthLoadingState());
    try {
      String authToken = await sharedPref.getString(
        key: sharedPref.bearerToken,
      );

      if (authToken.isEmpty) {
        emit(AuthLogoutState());
      } else {
        final result = await authRepository.checkLoginStatus(
          url: "user/check-user",
        );

        result.fold(
          (failure) {
            emit(AuthLogoutState());
          },
          (userResponse) {
            emit(AuthSuccessState(user: userResponse.user));
          },
        );
      }
    } catch (e) {
      emit(AuthLogoutState());
    }
  }
}
