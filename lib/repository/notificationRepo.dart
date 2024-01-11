// ignore_for_file: file_names

import 'dart:convert';
import 'package:joosecustomer/cubit/Response/response.dart';
import 'package:joosecustomer/networking/api_base_helper.dart';
import 'package:joosecustomer/networking/endpoints.dart';
import 'package:result_type/result_type.dart';

abstract class notificationRepository {

  Future<Result> notificationcount();
  Future<Result> messagecount();
  Future<Result> notificationList();
  Future<Result> messageList();
  Future<Result> GetoneNotif(String id);
  Future<Result> GetoneMessage(String id);

}

class NotificatioNRepository extends notificationRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  Future<Result> notificationcount() async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.notifications),
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      print(response.data);
      return Success(response.data);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }


  @override
  Future<Result> messagecount() async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.messages),
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      print(response.data);
      return Success(response.data);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }



  @override
  Future<Result> notificationList() async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.notifications),
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      print(response.data);
      return Success(response.data);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }

  @override
  Future<Result> messageList() async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.messages),
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      print(response.data);
      return Success(response.data);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }

  @override
  Future<Result> GetoneNotif(String id) async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.viewnotification) + "/" + id.toString(),
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {


      print("*****SINGLE Notif****"+response.data.toString());

      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }

  @override
  Future<Result> GetoneMessage(String id) async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.viewmessage) + "/" + id.toString(),
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {


      print("*****SINGLE Message****"+response.data.toString());

      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }


}
