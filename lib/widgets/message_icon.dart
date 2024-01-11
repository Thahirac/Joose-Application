import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joosecustomer/cubit/notification/notification_cubit.dart';
import 'package:joosecustomer/models/message_class.dart';
import 'package:joosecustomer/pages/notification_list_page.dart';
import 'package:joosecustomer/repository/notificationRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
class Message_Icon extends StatefulWidget {

  const Message_Icon({Key? key}) : super(key: key);

  @override
  _Message_IconState createState() => _Message_IconState();
}

class _Message_IconState extends State<Message_Icon> {

  late NotificationCubit messageCubit;
  int? messageCount;
  Widget message(){
    return messageCount==0? Container():Container(
      width: 50,
      height: 17,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.redAccent.shade700,),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: Text(
            " ${messageCount??""} new",
            style: TextStyle(fontSize: 8, color: Colors.white),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    messageCubit = NotificationCubit(NotificatioNRepository());
    // TODO: implement initState
    messageCubit.messagecount();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
      child: BlocProvider(
        create: (context) =>  messageCubit,
        child: BlocListener<NotificationCubit, NotificationState>(
          bloc:  messageCubit,
          listener: (context, state) {
            if(state is MessagecountLoading){}
            else if(state is MessagecountSuccessFull){
              messageCount=state.messageCount;
            }
            else if (state is MessagecountFail) {
              Utils.showDialouge(context, AlertType.error,
                  "No data", state.message);
            }
          },
          child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if(state is MessagecountSuccessFull){
                  return  message();
                }else if(state is MessagecountFail) {
                  return  message();
                }
                else {
                  return Container(
                    //                             color: Colors.white,
                  );
                }
              }),
        ),
      ),
    );
  }
}
