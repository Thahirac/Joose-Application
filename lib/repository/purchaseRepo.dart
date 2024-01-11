// ignore_for_file: file_names

import 'dart:convert';
import 'package:joosecustomer/cubit/Response/response.dart';
import 'package:joosecustomer/networking/api_base_helper.dart';
import 'package:joosecustomer/networking/endpoints.dart';
import 'package:result_type/result_type.dart';

abstract class dashbordRepository {

  Future<Result> getOrders();
  Future<Result>  getOrdersHistory();
  Future<Result>  getrewards();
  Future<Result>  getredeem();
}

class DashBordRepository extends dashbordRepository {
  ApiBaseHelper _helper = ApiBaseHelper();


  @override
  Future<Result> getOrders() async {
    String responseString = await _helper.postnobody(
        APIEndPoints.urlString(
          EndPoints.newpurchase,
        ),
        isHeaderRequired: true);

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      print("***NEW PURCHASE***"+response.data.toString());
      return Success(response.data);
    } else {
      return Failure(response.message);
    }
  }

  @override
  Future<Result> getOrdersHistory() async {
    String responseString = await _helper.get(
        APIEndPoints.urlString(
          EndPoints.purchasehistory,
        ),
        isHeaderRequired: true);

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      print("***PURCHASE HISTORY***"+response.data.toString());
      return Success(response.data);
    } else {
      return Failure(response.message);
    }
  }

  @override
  Future<Result> getrewards() async {
    String responseString = await _helper.get(
        APIEndPoints.urlString(
          EndPoints.myrewards,
        ),
        isHeaderRequired: true);

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      print("***REWARDS***"+response.data.toString());
      return Success(response.data);
    } else {
      return Failure(response.message);
    }
  }

  @override
  Future<Result> getredeem() async {
    String responseString = await _helper.postnobody(
        APIEndPoints.urlString(
          EndPoints.myredeem,
        ),
        isHeaderRequired: true);

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 200) {
      print("***REDEEM***"+response.data.toString());
      return Success(response.data);
    } else {
      return Failure(response.message);
    }
  }

}
