part of 'rewards_cubit.dart';


@immutable
abstract class RewardsState {}

class Initial extends RewardsState {}


class Loading extends RewardsState {}

class Successfull extends RewardsState {

  final int? points;

  Successfull(this.points);
}

class Faild extends RewardsState {
  final String msg;
  Faild(this.msg);
}
