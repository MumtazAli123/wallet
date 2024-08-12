// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wallet/app/modules/home/views/web_home_view.dart';
import 'package:wallet/app/modules/realstate/views/show_realstate.dart';

import '../app/modules/home/views/mob_home_view.dart';
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
   Timer.periodic(Duration(seconds: 1), (Timer t) => getCurrentLiveTimeDate());
  }

  @override
  Widget build(BuildContext context)
  {
    return AppBar(
      automaticallyImplyLeading: false,
      // leading: IconButton(
      //   icon: const Icon(Icons.menu, color: Colors.white,),
      //   onPressed: ()
      //   {
      //     Scaffold.of(context).openDrawer();
      //   },
      // ),
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
          Navigator.push(context, MaterialPageRoute(builder: (c)=>  WebHomeView()));
        },
        child:  wText(
          "${widget.title}",
          color: Colors.white,
          size: 26
        ),
      ),
      centerTitle: false,
      actions: [
        Row(
          children: [
            Padding(padding:  const EdgeInsets.all(8.0),
              child: wText(
                "$liveTime | $liveDate",
                color: Colors.white,
                size: 16,
              ),
            ),
            SizedBox(width: 140,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> WebHomeView()));
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

                },
                child: const Text(
                  "Vehicles ",
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
                  FirebaseAuth.instance.signOut();
                  Get.toNamed('/login');

                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        ),
      ],
    );
  }
}
