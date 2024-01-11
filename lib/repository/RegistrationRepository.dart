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


abstract class RegistrationRepository extends  UserAuthenticationRepository{
  Future<Result> registerUser(String? username, String? email,
      String? password, String password_confirmation);

  Future<Result> socialauthenticateUser(String? token, String? provider);

}

class UserRegRepository extends RegistrationRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  Future<Result> registerUser(String? username, String? email,
      String? password, String password_confirmation) async {
    String responseString =
        await (_helper.post(APIEndPoints.urlString(EndPoints.register), {
      "name": username,
      "email": email,
      "password": password,
      "password_confirmation": password_confirmation
    }));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {

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
