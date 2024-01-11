import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joosecustomer/cubit/rewardS/rewards_cubit.dart';
import 'package:joosecustomer/localization/app_localization.dart';
import 'package:joosecustomer/pages/redeem_page.dart';
import 'package:joosecustomer/repository/purchaseRepo.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/drawer.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:joosecustomer/widgets/notification_icon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  GlobalKey<ScaffoldState>? _key = GlobalKey();

  late RewardsCubit rewardsCubit;
  int? points;


  @override
  void initState() {
    rewardsCubit = RewardsCubit(DashBordRepository());
    Notification_Icon();
    super.initState();
    rewardsCubit.getrewards();
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
              _key!.currentState!.openDrawer();
            },
            icon: Icon(Icons.menu_rounded,size: 30,color: Colors.white,)),
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
          text: AppLocalizations.of(context).translate("MY REWARDS"),
          fontColor: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15,top: 25),
            child: GestureDetector(
                onTap: (){

                  // Navigator.push(
                  //   context,
                  //   PageRouteBuilder(
                  //     pageBuilder: (c, a1, a2) =>  Notification_page(),
                  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  //       var begin = Offset(1.0, 0.0);
                  //       var end = Offset.zero;
                  //       var tween = Tween(begin: begin, end: end);
                  //       var offsetAnimation = animation.drive(tween);
                  //       return SlideTransition(
                  //         position: offsetAnimation,
                  //         child: child,
                  //       );
                  //     },
                  //     transitionDuration: Duration(milliseconds: 500),
                  //   ),
                  // );

                },
                child: Notification_Icon()),
          ),
        ],
      ),

      body:  SafeArea(
        child: BlocProvider(
            create: (context) => rewardsCubit,
            child: BlocListener<RewardsCubit, RewardsState>(
              bloc: rewardsCubit,
              listener: (context, state) {
                if (state is Initial) {}
                if (state is Loading) {
                } else if (state is Successfull) {
                  points = state.points;
                } else if (state is Faild) {
                  Utils.showDialouge(
                      context, AlertType.error, "Oops!", state.msg);
                }

              },
              child: BlocBuilder<RewardsCubit, RewardsState>(
                  builder: (context, state) {
                    // print("gjgfjhfjf" + cart_count.toString());
                    if (state is Initial) {}
                    if (state is Loading) {
                      return Column(
                        children:  [
                          SizedBox(
                            height: MediaQuery.of(context).size.height* 0.45,
                          ),
                          const Center(
                            child: CupertinoActivityIndicator(
                              radius: 10,
                            ),
                          ),
                        ],
                      );
                    } else if (state is Successfull) {
                      return rewardsform();
                    } else if (state is Faild) {
                      return rewardsform();
                    }
                    else {
                      return Container();
                    }
                  }),
            )),
      ),





    );
  }

  Widget rewardsform(){
    return  SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        // decoration:  const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [
        //         Color.fromARGB(1,255, 255,255),
        //         Color.fromARGB(1,254, 227,230),
        //         Color.fromARGB(255,254,200,206),
        //         Color.fromARGB(255,230,0,23)
        //       ],
        //     )),
        child: Column(
          children: [

            // Stack(
            //   children: [
            //     Container(
            //       width: MediaQuery.of(context).size.width,
            //       height: 160,
            //       child: Image.asset(
            //         "assets/images/giftimg.png",
            //         fit: BoxFit.fitWidth,
            //       ),
            //     ),
            //     Positioned(
            //       top: 40,
            //       left: 140,
            //       child: Column(
            //         children: [
            //
            //
            //           Container(
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 Container(
            //                   child: const Text( "CURRENT POINTS",
            //                     style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,),
            //                   ),
            //                 ),
            //
            //               ],
            //             ),
            //           ),
            //
            //           SizedBox(height: 5,),
            //           Container(
            //             height: 55,
            //             width: 130,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(15.0),
            //             color:  Color.fromARGB(255,255,111,0),
            //             ),
            //             child: Center(
            //                 child:  JooseText(text: "${data.rewardslist?['points']??"0"}",fontWeight: FontWeight.bold,fontSize: 24,fontColor: Colors.white,)
            //
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),


            Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child:Text( AppLocalizations.of(context).translate("CURRENT POINT"),
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,),
                              ),
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: 5,),
                      Container(
                        height: 55,
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color:  Color.fromARGB(255,255,111,0),
                        ),
                        child: Center(
                            child:  JooseText(text: "${points??"0"}",fontWeight: FontWeight.bold,fontSize: 24,fontColor: Colors.white,)

                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),


            points! >= 7 ?  Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: JooseText(
                      text:AppLocalizations.of(context).translate("Redeem"),
                      fontColor: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),

                ],
              ),
            ):Container(),

            points! >= 7 ?  Padding(
              padding: const EdgeInsets.only(left: 30, right: 30,top: 20),
              child: InkWell(
                splashColor: Color.fromARGB(255,255,111,0),
                highlightColor: Colors.white,
                focusColor: Colors.white,
                onTap: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => RedeemPage(),
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
                child: Container(
                  height: 78,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: LinearGradient(
                        colors: [

                          Color.fromARGB(255,255,111,0),
                          Color.fromARGB(255,247,79,15),
                          Color.fromARGB(255,247,79,15),
                          Color.fromARGB(255,232,22,43)
                          //add more colors for gradient
                        ],
                        begin: Alignment.topLeft, //begin of the gradient color
                        end: Alignment.bottomRight, //end of the gradient color
                        stops: [0, 0.2, 0.5, 0.8] //stops for individual color
                      //set the stops number equal to numbers of color
                    ),
                  ),
                  child: Center(
                      child: Image.asset(
                        "assets/images/gift.png",
                        width: 35,
                        height: 35,
                        color: Colors.white,
                      )
                  ),
                ),
              ),
            ) :Container(),




          ],
        ),
      ),
    );
  }


}
