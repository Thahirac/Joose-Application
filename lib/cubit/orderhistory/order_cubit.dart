import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:joosecustomer/models/purchasehistory_class.dart';
import 'package:joosecustomer/repository/purchaseRepo.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {

  List<Purchase>? purchase;

  OrderCubit(this.dashBordRepository) : super(OrderInitial());
  final DashBordRepository dashBordRepository;


  Future<void> getOrderList() async {
    emit(OrderLoading());
    Result result = await dashBordRepository.getOrdersHistory();
    if (result.isSuccess) {

      dynamic orderItems = result.success['purchase'];
      purchase = OrdersList(orderItems);


      emit(OrderSuccessfull(purchase));
    }
    else {
      emit(PurchaseFaild(result.failure));
    }
  }
}


List<Purchase> OrdersList(List data) {
  List<Purchase> orderlist = [];
  var length = data.length;

  for (int i = 0; i < length; i++) {
    Purchase products = Purchase(
      purchaseDate: data[i]?["purchase_date"],
      quantity: data[i]?["quantity"],
      storeId: data[i]?["store_id"],
      purchaseType: data[i]?["purchase_type"],
      qrFileNameUrl: data[i]?["qr_file_name_url"],
    );
    orderlist.add(products);
  }
  return orderlist;
}

