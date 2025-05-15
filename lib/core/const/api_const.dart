import 'package:flutter/material.dart';

@immutable
class ApiConstants {
  // Base URL for different environments
  static const String BASE_URL_DEV = "https://dev-api.example.com";
  static const String BASE_URL_STAGING = "https://staging-api.example.com";
  static const String BASE_URL_PROD = "https://api.example.com";

  // Auth API paths (endpoints)
  static const String LOGIN = "$BASE_URL_DEV/auth/login";
  static const String LOGOUT = "$BASE_URL_DEV/auth/logout";
  static const String REGISTER = "$BASE_URL_DEV/auth/register";
  static const String PROFILE = "$BASE_URL_DEV/auth/profile";
  static const String DELETE_ACCOUNT = "$BASE_URL_DEV/auth/delete-account";
  static const String FORGET_PASSWORD = "$BASE_URL_DEV/auth/forget-password";
  static const String GET_OTP = "$BASE_URL_DEV/auth/get-otp";
  static const String RESEND_OTP = "$BASE_URL_DEV/auth/resend-otp";
  static const String CHANGE_PASSWORD = "$BASE_URL_DEV/auth/change-password";
  static const String RESET_PASSWORD = "$BASE_URL_DEV/auth/reset-password";
  static const String VERIFY_OTP = "$BASE_URL_DEV/auth/verify-otp";

  // Post API paths
  static const String CREATE_POST = "$BASE_URL_DEV/auth/verify-otp";
  static const String GET_ALL_POSTS = "$BASE_URL_DEV/auth/verify-otp";
  static const String UPDATE_POST = "$BASE_URL_DEV/auth/verify-otp";
  static const String GET_POST_BY_ID = "$BASE_URL_DEV/auth/verify-otp";
  static const String DELETE_POST = "$BASE_URL_DEV/auth/verify-otp";

  // Timeout settings for network calls
  static const int TIMEOUT_DURATION_IN_SECONDS = 30;
}
