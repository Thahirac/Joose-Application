part of 'purchase_cubit.dart';


@immutable
abstract class PurchaseState {}

class PurchaseInitial extends PurchaseState {}


class PurchaseLoading extends PurchaseState {}

class PurchaseSuccessfull extends PurchaseState {

  final  String? qrFileNameUrl;

  PurchaseSuccessfull(this.qrFileNameUrl);
}

class PurchaseFaild extends PurchaseState {
  final String msg;
  PurchaseFaild(this.msg);
}
