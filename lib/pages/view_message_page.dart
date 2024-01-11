import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joosecustomer/cubit/notification/notification_cubit.dart';
import 'package:joosecustomer/models/message_class.dart';
import 'package:joosecustomer/models/notification_class.dart';
import 'package:joosecustomer/repository/notificationRepo.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/drawer.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_list_page.dart';

class View_message_page extends StatefulWidget {
  final String? id;
  const View_message_page({Key? key,this.id,}) : super(key: key);

  @override
  _View_message_pageState createState() => _View_message_pageState();
}

class _View_message_pageState extends State<View_message_page> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  SingleMessage? message;

  late NotificationCubit viewmsgCubit;

  @override
  void initState() {
    viewmsgCubit = NotificationCubit(NotificatioNRepository());
    // TODO: implement initStat
    viewmsgCubit.Getonemessage(widget.id!);
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
          text: "MESSAGE",
          fontColor: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),

      body: SingleChildScrollView(
        child: BlocProvider(
            create: (context) => viewmsgCubit,
            child: BlocListener<NotificationCubit, NotificationState>(
              bloc:  viewmsgCubit,
              listener: (context, state) {
                if (state is ViewmsgLoading) {}
                else if (state is ViewmsgSuccess) {
                  message=state.message;
                } else if (state is ViewmsgFail) {
                  Utils.showDialouge(context, AlertType.error, "Oops!", state.msg);
                }
              },
              child: BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    if (state is ViewmsgLoading) {
                      return Column(
                        children: const [
                          SizedBox(height: 360,),
                          Center(child: CupertinoActivityIndicator(radius: 10,),),
                        ],
                      );
                    } else if (state is ViewmsgSuccess) {
                      return viewmsgform();
                    } else if (state is  ViewmsgFail) {
                      return  viewmsgform();
                    }
                    else {
                      return  viewmsgform();
                    }
                  }),
            )),
      ),
    );
  }

  Widget viewmsgform(){
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

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => Message_page(),
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
                    text: "${message?.title!.toUpperCase()??""}",
                    fontColor: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
                Expanded(child: SizedBox()),
                JooseText(
                  text: "${message?.time??""}",
                  fontColor: Colors.red,
                  fontSize: 10,),

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20,top: 15),
            margin: EdgeInsets.only(top: 0, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JooseText(text:"""${message?.description??""}""",
                  fontSize: 13, alignment:TextAlign.justify,
                ),
              ],
            ),
          ),




          SizedBox(height: 30,),
        ],
      ),
    );
  }



}
