// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables


import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wallet/app/modules/realstate/views/show_realstate.dart';
import 'package:wallet/widgets/responsive.dart';

import 'mix_widgets.dart';



class NavAppBar extends StatefulWidget implements PreferredSizeWidget{
 final PreferredSizeWidget? preferredSizeWidget;
 final String? title;
  const NavAppBar({super.key, this.preferredSizeWidget,   this.title});

  @override
  State<NavAppBar> createState() => _NavAppBarState();

  @override
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}



class _NavAppBarState extends State<NavAppBar>{
  String liveTime = "";
  String liveDate = "";

  String formatCurrentLiveTime(DateTime time) {
    return DateFormat("hh: mm: ss a").format(time);
  }

  String formatCurrentLiveDate(DateTime time) {
    return DateFormat("dd MMMM, yyyy").format(time);
  }

  getCurrentLiveTimeDate() {
    liveTime = formatCurrentLiveTime(DateTime.now());
    liveDate = formatCurrentLiveDate(DateTime.now());

    setState(() {
      liveTime;
      liveDate;
    });
  }

  @override
  void initState() {
    super.initState();
   // Timer.periodic(Duration(seconds: 1), (Timer t) => getCurrentLiveTimeDate());
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobiView: _buildMobileAppBar(),
      webView: _buildWebAppBar(),
    );
  }

  _buildMobileAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration:  BoxDecoration(
            gradient: LinearGradient(
              colors:
              [
                Colors.blue[900]!,
                Colors.deepPurpleAccent,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
      ),
      title: GestureDetector(
        onTap: ()
        {
          Get.offAllNamed('/home');
        },
        child:  wText(
          "${widget.title}",
          color: Colors.white,
          size: 16
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(onPressed: (){
          Get.offAllNamed('/home');
        }, icon: Icon(EvaIcons.home, color: Colors.white,)),

        IconButton(onPressed: (){
          Get.to( () => ShowRealstate());
        }, icon: Icon(Icons.real_estate_agent, color: Colors.white,)),
        // vehicles
        IconButton(onPressed: (){
          Get.toNamed('/vehicle');
        }, icon: Icon(Icons.local_taxi, color: Colors.white,)),
      //   products
        IconButton(onPressed: (){
          Get.toNamed('/products');
        }, icon: Icon(Icons.shopping_bag_sharp, color: Colors.white,)),
        // profile
        // logout
      ],
    );
  }

  _buildWebAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white,),
        onPressed: ()
        {
          Scaffold.of(context).openDrawer();
        },
      ),
      flexibleSpace: Container(
        decoration:  BoxDecoration(
            gradient: LinearGradient(
              colors:
              [
                Colors.blue[900]!,
                Colors.deepPurpleAccent,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
      ),
      title: GestureDetector(
        onTap: ()
        {
          Get.offAllNamed('/home');
        },
        child:  wText(
          "${widget.title}",
          color: Colors.white,
          size: 16
        ),
      ),
      centerTitle: false,
      actions: [
        // time and date
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(
        //     "$liveTime | $liveDate",
        //     style: TextStyle(
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        SizedBox(width: 50.0,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: ()
              {
                Get.offAllNamed('/home');
              },
              child: const Text(
                "Home",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
          ),
        ),

        Text(
          "|",
          style: TextStyle(
            color: Colors.white,
          ),
        ),


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: ()
            {
              Get.to( () => ShowRealstate());

            },
            child: const Text(
              "Real Estate",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),

        const Text(
          "|",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: ()
            {
              Get.toNamed('/vehicle');

            },
            child: const Text(
              "Vehicles ",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        // home



      ],
    );
  }
}
