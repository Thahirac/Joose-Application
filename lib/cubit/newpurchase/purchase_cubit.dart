import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:joosecustomer/repository/purchaseRepo.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {

  String? qrFileNameUrl;

  PurchaseCubit(this.dashBordRepository) : super(PurchaseInitial());
  final DashBordRepository dashBordRepository;


  Future<void> getOrders() async {
    emit(PurchaseLoading());
    Result result = await dashBordRepository.getOrders();
    if (result.isSuccess) {

      qrFileNameUrl= result.success["qr_file_name_url"];

      emit(PurchaseSuccessfull(qrFileNameUrl));
    }
    else {
      emit(PurchaseFaild(result.failure));
    }
  }
}




