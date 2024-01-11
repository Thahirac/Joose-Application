// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'package:joosecustomer/cubit/Response/response.dart';
import 'package:joosecustomer/networking/api_base_helper.dart';
import 'package:joosecustomer/networking/endpoints.dart';
import 'package:joosecustomer/repository/authenticationRepo.dart';
import 'package:joosecustomer/utils/user_manager.dart';
import 'package:result_type/result_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CheckOrderRepository extends UserAuthenticationRepository {

  Future<Result> authenticateUser(String? username, String? password);

  Future<Result> socialauthenticateUser(String? token, String? provider);
}

class UserLoginRepository extends CheckOrderRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  Future<Result> authenticateUser(String? username, String? password) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.login),
        {
          "email": username,
          "password": password
        }));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      String token = response.data["token"];
      saveToken(token);
      UserManager.instance.setUserLoggedIn(true);
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }


  @override
  Future<Result> socialauthenticateUser(String? token, String? provider) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.sociallogin),
        {
          "token": token,
          "provider": provider,
        }
    )
    );
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      String token = response.data["token"];
      saveToken(token);
      UserManager.instance.setUserLoggedIn(true);
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }


}
