import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:joosecustomer/repository/purchaseRepo.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'redeem_state.dart';

class RedeemCubit extends Cubit<RedeemState> {

  String? qrFileNameUrl;

  RedeemCubit(this.dashBordRepository) : super(Initial());
  final DashBordRepository dashBordRepository;


  Future<void> getredeem() async {
    emit(Loading());
    Result result = await dashBordRepository.getredeem();
    if (result.isSuccess) {

      qrFileNameUrl = result.success["qr_file_name_url"];

      emit(Successfull(qrFileNameUrl));
    }
    else {
      emit(Faild(result.failure));
    }
  }
}




