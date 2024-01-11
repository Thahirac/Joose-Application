import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joosecustomer/models/message_class.dart';
import 'package:joosecustomer/models/notification_class.dart';
import 'package:joosecustomer/repository/notificationRepo.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {

  int? notificationCount;
  int? messageCount;
  List<MyNotification>? notifications;
  List<Message>? messages;
  SingleNotification? notification;
  SingleMessage? message;


  NotificationCubit(this.notificatioNRepository) : super(NotificationInitial());
  final NotificatioNRepository notificatioNRepository;

  Future<void> notificationcount() async {
    emit(NotificationLoading());
    Result? result = await notificatioNRepository.notificationcount();
    if (result.isSuccess) {

      messageCount =result.success['notification_count'];
      print("*************MESSAGE COUNT*****************"+messageCount.toString());


      emit(NotificationSuccessFull(messageCount));
    } else {
      emit(NotificationFail(result.failure));
    }
  }


  Future<void> messagecount() async {
    emit(MessagecountLoading());
    Result? result = await notificatioNRepository.messagecount();
    if (result.isSuccess) {

      notificationCount =result.success['messages_count'];
      print("*************FEE**********************"+notificationCount.toString());


      emit(MessagecountSuccessFull(notificationCount));
    } else {
      emit(MessagecountFail(result.failure));
    }
  }

  Future<void> notificationList() async {
    emit(NotificationlistLoading());
    Result? result = await notificatioNRepository.notificationList();
    if (result.isSuccess) {

      dynamic kartItems = result.success['notifications'];
      notifications = NotificationsList(kartItems);


      emit(NotificationlistSuccessFull(notifications));
    } else {
      emit(NotificationlistFail(result.failure));
    }
  }


  Future<void> messageList() async {
    emit(MessageLoading());
    Result? result = await notificatioNRepository.messageList();
    if (result.isSuccess) {

      dynamic kartItems = result.success['messages'];
      messages = MessageList(kartItems);


      emit(MessageSuccessFull(messages));
    } else {
      emit(MessageFail(result.failure));
    }
  }



  Future<void> GetoneNotif(String id) async {
    emit(ViewnotifLoading());
    Result? result = await notificatioNRepository.GetoneNotif(id);
    if (result.isSuccess) {

      dynamic notif = result.success['notification'];

      notification = SingleNotification(
        id:  notif['id'],
        time:  notif["time"],
        title:  notif["title"],
        description: notif["description"],
      );

      emit(ViewnotifSuccess(notification));
    } else {
      emit(ViewnotifFail(result.failure));
    }
  }


  Future<void> Getonemessage(String id) async {
    emit(ViewmsgLoading());
    Result? result = await notificatioNRepository.GetoneMessage(id);
    if (result.isSuccess) {

      dynamic notif = result.success['message'];

      message = SingleMessage(
        id:  notif['id'],
        time:  notif["time"],
        title:  notif["title"],
        description: notif["description"],
      );

      emit(ViewmsgSuccess(message));
    } else {
      emit(ViewmsgFail(result.failure));
    }
  }


}

List<MyNotification> NotificationsList(List data) {
  List<MyNotification> notificationlist = [];
  var length = data.length;
  print("**********notification***LENGTH**********"+length.toString());

  for (int i = 0; i < length; i++) {
    MyNotification notifs = MyNotification(
        id: data[i]?['id'],
        time: data[i]?["time"],
        title: data[i]?["title"],
        description: data[i]?["description"],
    );
    notificationlist.add(notifs);
  }
  return notificationlist;
}



List<Message> MessageList(List data) {
  List<Message> messagelist = [];
  var length = data.length;
  print("**********message***LENGTH**********"+length.toString());

  for (int i = 0; i < length; i++) {
    Message msgs = Message(
      id: data[i]?['id'],
      time: data[i]?["time"],
      readAt: data[i]?["read_at"],
      title: data[i]?["title"],
      description: data[i]?["description"],
    );
    messagelist.add(msgs);
  }
  return messagelist;
}