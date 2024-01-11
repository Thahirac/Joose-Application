import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joosecustomer/cubit/notification/notification_cubit.dart';
import 'package:joosecustomer/localization/app_localization.dart';
import 'package:joosecustomer/models/message_class.dart';
import 'package:joosecustomer/models/notification_class.dart';
import 'package:joosecustomer/pages/dash_board.dart';
import 'package:joosecustomer/pages/view_message_page.dart';
import 'package:joosecustomer/pages/view_notification_page.dart';
import 'package:joosecustomer/repository/notificationRepo.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Message_page extends StatefulWidget {

  const Message_page({Key? key}) : super(key: key);

  @override
  _Message_pageState createState() => _Message_pageState();
}

class _Message_pageState extends State<Message_page> {



  late NotificationCubit viewNotifCubit;
  List<Message>? messages=[];


  Widget msglist(){
    if(messages?.length==0){
      return notiEmpty();
    }else{
      return ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: messages?.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 7, right: 7, top: 5),
              child: Column(
                children: [
                  ListTile(
                    onTap: (){

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => View_message_page(id: messages?[index].id,),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            var begin = Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var tween = Tween(begin: begin, end: end);
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          transitionDuration: Duration(milliseconds: 500),
                        ),
                      );


                      // Navigator.push(context, PageTransition(
                      //     duration: Duration(milliseconds: 500),
                      //     type: PageTransitionType.rightToLeft,
                      //     child:  View_notification_page(id: notifications?[count].id,),
                      //     inheritTheme: true,
                      //     ctx: context),);

                    },
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [

                        messages?[index].readAt==null?  JooseText(
                          text: "${messages?[index].title!.toUpperCase()??""}",fontColor: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ): JooseText(
                          text: "${messages?[index].title!.toUpperCase()??""}",fontColor: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                         ),

                        SizedBox(height: 2,),

                        JooseText(
                          text: AppLocalizations.of(context).translate("Message from Admin"),fontColor: Colors.black,
                          fontSize: 8,
                        ),

                      ],
                    ),
                    trailing: JooseText(
                      text: "${messages?[index].time??""}",fontColor: Colors.red,
                      fontSize: 10,
                      over: TextOverflow.ellipsis,
                    ),
                  ),

                  Divider(
                    color: Colors.grey.shade700,
                    height: 13,
                    thickness: 0.3,
                  ),

                ],
              ),
            );
          });
    }

  }

  @override
  void initState() {
    viewNotifCubit = NotificationCubit(NotificatioNRepository());
    // TODO: implement initState
    viewNotifCubit.messageList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading:  InkWell(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => Dashboard(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var begin = Offset(1.0, 0.0);
                var end = Offset.zero;
                var tween = Tween(begin: begin, end: end);
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          ),
          child:  Padding(
            padding: EdgeInsets.only(left: 10,top: 30),
            child:  JooseText(
              text:  AppLocalizations.of(context).translate("cl"),
              fontColor: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),

        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        elevation: 0.01,
        flexibleSpace: Container(
          decoration:
          const BoxDecoration(
            image: DecorationImage(
              image: AssetImage( "assets/images/appbarimg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: JooseText(
          text:  AppLocalizations.of(context).translate("MESSAGE"),
          fontColor: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: BlocProvider(
        create: (context) =>  viewNotifCubit,
        child: BlocListener<NotificationCubit, NotificationState>(
          bloc:  viewNotifCubit,
          listener: (context, state) {
            if (state is MessageLoading) {}

            else if(state is MessageSuccessFull){
              messages=state.messages;
            }
            else if (state is MessageFail) {
              Utils.showDialouge(context, AlertType.error,
                  "No data", state.message);
            }
          },
          child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is MessageLoading) {
                  return Column(
                    children: const [
                      SizedBox(height: 360,),
                      Center(child: CupertinoActivityIndicator(radius: 10,),),
                    ],
                  );
                }
                else if(state is MessageSuccessFull){
                  return msglist();
                }else if(state is MessageFail) {
                  return msglist();
                }
                else {
                  return Container(color: Colors.white54,);
                }
              }
          ),
        ),
      ),
    );
  }

  Widget notiEmpty(){
    return Column(
      children:  [
        SizedBox(
          height: MediaQuery.of(context).size.height* 0.23,
        ),
         Center(
          child: JooseText(text:  AppLocalizations.of(context).translate("No Message found Here"),  fontColor: Colors.black, fontWeight: FontWeight.w600, fontSize: 20,),
        ),
      ],
    );
  }


}
