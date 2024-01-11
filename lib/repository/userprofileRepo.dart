// ignore_for_file: file_names

import 'dart:convert';
import 'package:joosecustomer/cubit/Response/response.dart';
import 'package:joosecustomer/networking/api_base_helper.dart';
import 'package:joosecustomer/networking/endpoints.dart';
import 'package:result_type/result_type.dart';

abstract class userprofileRepository {
  Future<Result> UserProfile();
  Future<Result> ChangePassWord(String old_password, String password, String password_confirmation);
  Future<Result> UserProfileUpdate(String name, String address, String phone,String zip, String city, String country,String dob,String contact_person,String coc,String vat_number);
}

class UserprofileRepository extends userprofileRepository {
  ApiBaseHelper _helper = ApiBaseHelper();


  @override
  Future<Result> UserProfile() async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.viewmyprofile),
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      var k = response.data['user'];
      print(response.data['user']);
      return Success(response.data['user']);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }


  @override
  Future<Result> ChangePassWord(String old_password, String password,
      String password_confirmation) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.changepass),
        {
          "old_password": old_password,
          "password": password,
          "password_confirmation": password_confirmation,
        },
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      //  var k = response.data['user'];
      // print(response.data['user']);
      return Success(response.message);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }


  @override
  Future<Result> UserProfileUpdate(String name, String address, String phone,
      String zip, String city, String country,String dob,String contact_person,String coc,String vat_number) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.updatemyprofile),
        {
          "name": name,
          "address": address,
          "phone": phone,
          "zip": zip,
          "city": city,
          "country": country,
          "dob": dob,
          "contact_person": contact_person,
          "coc":coc,
          "vat_number":vat_number
        },
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      var k = response.data['user'];
      print(response.data['user']);
      return Success(response.data['user']);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }



}
