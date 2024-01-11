part of 'order_cubit.dart';


@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}


class OrderLoading extends OrderState {}

class OrderSuccessfull extends OrderState {

  final  List<Purchase>? purchase;

  OrderSuccessfull(this.purchase);
}

class PurchaseFaild extends OrderState {
  final String msg;
  PurchaseFaild(this.msg);
}
