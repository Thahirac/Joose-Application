import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joosecustomer/cubit/notification/notification_cubit.dart';
import 'package:joosecustomer/models/notification_class.dart';
import 'package:joosecustomer/repository/notificationRepo.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/drawer.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class View_notification_page extends StatefulWidget {
  final String? id;
  const View_notification_page({Key? key,this.id,}) : super(key: key);

  @override
  _View_notification_pageState createState() => _View_notification_pageState();
}

class _View_notification_pageState extends State<View_notification_page> {


  GlobalKey<ScaffoldState> _key = GlobalKey();

  SingleNotification? notification;

  late NotificationCubit viewNotifCubit;


  @override
  void initState() {
    viewNotifCubit = NotificationCubit(NotificatioNRepository());
    // TODO: implement initStat
    viewNotifCubit.GetoneNotif(widget.id!);
    //personal_message_Controller = TextEditingController(text: message);
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drowerAfterlogin(),
      key: _key,
      resizeToAvoidBottomInset: false,
      appBar:  AppBar(
        leading: IconButton(
            onPressed: (){
              _key.currentState!.openDrawer();
            },
            icon: Icon(Icons.menu_rounded,size: 30,color: Colors.white,)),
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        elevation: 0.01,
        flexibleSpace: Container(
          decoration:
          BoxDecoration(
            image: DecorationImage(
              image: AssetImage( "assets/images/appbarimg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: JooseText(
          text: "NOTIFICATION",
          fontColor: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),

      body: SingleChildScrollView(
        child: BlocProvider(
            create: (context) => viewNotifCubit,
            child: BlocListener<NotificationCubit, NotificationState>(
              bloc:  viewNotifCubit,
              listener: (context, state) {
                if (state is ViewnotifLoading) {}
                else if (state is ViewnotifSuccess) {
                  notification=state.notification;
                } else if (state is ViewnotifFail) {
                  Utils.showDialouge(context, AlertType.error, "Oops!", state.msg);
                }
              },
              child: BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    if (state is ViewnotifLoading) {
                      return Column(
                        children: const [
                          SizedBox(height: 360,),
                          Center(child: CupertinoActivityIndicator(radius: 10,),),
                        ],
                      );
                    } else if (state is ViewnotifSuccess) {
                      return  notificationdetailform();
                    } else if (state is  ViewnotifFail) {
                      return  notificationdetailform();
                    }
                    else {
                      return  notificationdetailform();
                    }
                  }),
            )),
      ),

    );
  }

  Widget notificationdetailform(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Canvas.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //Back Button
          Container(
              margin: EdgeInsets.only(left: 20, top: 25,bottom: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {

                      Navigator.pop(context);
                      // Navigator.push(context, PageTransition(
                      //     duration: Duration(milliseconds: 500),
                      //     type: PageTransitionType.leftToRight,
                      //     child:  Notification_page(),
                      //     inheritTheme: true,
                      //     ctx: context),);

                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),

                ],
              )),


          SizedBox(height: 25,),

          Container(
            height: 30,
            padding: EdgeInsets.only(left: 20, right: 20),
            margin: EdgeInsets.only(top: 0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                JooseText(
                    text: "${notification?.title}",
                    fontColor: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
                Expanded(child: SizedBox()),
                JooseText(
                  text: "${notification?.time}",
                  fontColor: Colors.red,
                  fontSize: 10,),

              ],
            ),
          ),
          Container(
            height: 30,
            padding: EdgeInsets.only(left: 20, right: 20),
            margin: EdgeInsets.only(top: 0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                JooseText(
                    text: "${notification?.description}",
                    fontColor: Colors.black,
                    fontSize: 9,
                    fontWeight: FontWeight.w500),
                Expanded(child: SizedBox()),
              ],
            ),
          ),




          SizedBox(height: 30,),
        ],
      ),
    );
  }



}
