import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:joosecustomer/repository/purchaseRepo.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'rewards_state.dart';

class RewardsCubit extends Cubit<RewardsState> {

  int? points;

  RewardsCubit(this.dashBordRepository) : super(Initial());
  final DashBordRepository dashBordRepository;


  Future<void> getrewards() async {
    emit(Loading());
    Result result = await dashBordRepository.getrewards();
    if (result.isSuccess) {

      points = result.success["points"];

      emit(Successfull(points));
    }
    else {
      emit(Faild(result.failure));
    }
  }
}





