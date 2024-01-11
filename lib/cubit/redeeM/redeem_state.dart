part of 'redeem_cubit.dart';


@immutable
abstract class RedeemState {}

class Initial extends RedeemState {}


class Loading extends RedeemState {}

class Successfull extends RedeemState {

  final String? qrFileNameUrl;

  Successfull(this.qrFileNameUrl);
}

class Faild extends RedeemState {
  final String msg;
  Faild(this.msg);
}