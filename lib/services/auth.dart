import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:todo_app_api/configs/backend_configs.dart';
import 'package:todo_app_api/configs/end_point.dart';
import 'package:todo_app_api/models/login.dart';
import 'package:todo_app_api/models/user.dart';

import '../models/register_user.dart';

class AuthServices {
  ///Register
  Future<RegisterResponseModel> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    http.Response response = await http.post(
        Uri.parse('https://todo-nu-plum-19.vercel.app/users/register'),
        body: {"name": name, "email": email, "password": password});

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterResponseModel.fromJson(jsonDecode(response.body));
    } else {
      return RegisterResponseModel();
    }
  }

  ///Login
  Future<LoginResponseModel> loginUser(
      {required String email, required String password}) async {
    http.Response response = await http.post(
        Uri.parse(BackendConfigs.kBaseUrl + EndPoints.kLogin),
        body: jsonEncode({"email": email, "password": password}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } else {
      return LoginResponseModel();
    }
  }

  ///Get User Data
  Future<UserModel> getUserProfile({required String token}) async {
    log(token);
    http.Response response = await http.get(
        Uri.parse(BackendConfigs.kBaseUrl + EndPoints.kGetProfile),
        headers: {'Authorization': token});

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      return UserModel();
    }
  }
}
