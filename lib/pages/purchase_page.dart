import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joosecustomer/cubit/newpurchase/purchase_cubit.dart';
import 'package:joosecustomer/localization/app_localization.dart';
import 'package:joosecustomer/repository/purchaseRepo.dart';
import 'package:joosecustomer/utils/util.dart';
import 'package:joosecustomer/widgets/drawer.dart';
import 'package:joosecustomer/widgets/jooseAlert.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:joosecustomer/widgets/notification_icon.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_image/shimmer_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_list_page.dart';
class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  GlobalKey<ScaffoldState>? _key = GlobalKey();

  late PurchaseCubit purchaseCubit;
  String? imgUrl;


  @override
  void initState() {
    purchaseCubit = PurchaseCubit(DashBordRepository());
    Notification_Icon();
    super.initState();
    purchaseCubit.getOrders();
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
        title:  JooseText(
          text:AppLocalizations.of(context).translate("Purchase"),
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
                child:  Notification_Icon()),
          ),
        ],
      ),

      body: SafeArea(
        child: BlocProvider(
            create: (context) => purchaseCubit,
            child: BlocListener<PurchaseCubit, PurchaseState>(
              bloc: purchaseCubit,
              listener: (context, state) {
                if (state is PurchaseInitial) {}
                if (state is PurchaseLoading) {
                } else if (state is PurchaseSuccessfull) {
                  imgUrl = state.qrFileNameUrl;
                } else if (state is PurchaseFaild) {
                  Utils.showDialouge(
                      context, AlertType.error, "Oops!", state.msg);
                }

              },
              child: BlocBuilder<PurchaseCubit, PurchaseState>(
                  builder: (context, state) {
                    // print("gjgfjhfjf" + cart_count.toString());
                    if (state is PurchaseInitial) {}
                    if (state is PurchaseLoading) {
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
                    } else if (state is PurchaseSuccessfull) {
                      return purchaseqr();
                    } else if (state is PurchaseFaild) {
                      return purchaseqr();
                    }
                    else {
                      return Container();
                    }
                  }),
            )),
      ),

    );
  }
  Widget purchaseqr(){
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
        children: [

          //Back Button
          Container(
              margin: EdgeInsets.only(left: 20, top: 25,bottom: 150),
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


          Align(
            alignment: Alignment.center,
            child: Container(
              color: Colors.white,
              // decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200,width:2)),
              width: 270,
              height: 270,
              child:
              Center(
                child: ProgressiveImage(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade300,
                  width: 230,
                  height: 230,
                  fit: BoxFit.cover,
                  image:  "${imgUrl}",
                ),
              ),

            ),

          ),

        ],
      ),
    );
  }
}
