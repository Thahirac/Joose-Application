part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}


//Notification count

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccessFull extends NotificationState {
  final int? notificationCount;
  NotificationSuccessFull(this.notificationCount);
}

class NotificationFail extends NotificationState {
  final String message;

  NotificationFail(this.message);
}

//Notifications

class NotificationlistLoading extends NotificationState {}

class NotificationlistSuccessFull extends NotificationState {

  final List<MyNotification>? notifications;
  NotificationlistSuccessFull(this.notifications);
}

class NotificationlistFail extends NotificationState {
  final String message;

  NotificationlistFail(this.message);
}

//view notification

class ViewnotifLoading extends NotificationState {}

class ViewnotifSuccess extends NotificationState {


  final SingleNotification? notification;

  ViewnotifSuccess(this.notification);
}

class ViewnotifFail extends NotificationState {

  final String msg;

  ViewnotifFail(this.msg);

}

//Message count

class MessagecountLoading extends NotificationState {}

class MessagecountSuccessFull extends NotificationState {
  final int? messageCount;
  MessagecountSuccessFull(this.messageCount);
}

class MessagecountFail extends NotificationState {
  final String message;

  MessagecountFail(this.message);
}



//Messages

class MessageLoading extends NotificationState {}

class MessageSuccessFull extends NotificationState {
  List<Message>? messages;
  MessageSuccessFull(this.messages);
}

class MessageFail extends NotificationState {
  final String message;

  MessageFail(this.message);
}

//view message

class ViewmsgLoading extends NotificationState {}

class ViewmsgSuccess extends NotificationState {


  final SingleMessage? message;

  ViewmsgSuccess(this.message);
}

class ViewmsgFail extends NotificationState {

  final String msg;

  ViewmsgFail(this.msg);

}