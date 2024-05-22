// ignore_for_file: prefer_const_constructors
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';

class SliderPics extends StatelessWidget {
  const SliderPics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(3),
          height: MediaQuery.of(context).size.height / 1.5,
          child: CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 1.5,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: true,
              // aspectRatio: 1.0,
              enlargeCenterPage: true,
            ),
            items: itemsList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(i),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      // chx/ild: Text(
                      //   itemsList[itemsList.indexOf(i)],
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
      // body: ListView.builder(
      //   itemCount: itemsList.length,
      //   itemBuilder: (context, index) {
      //     return Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Container(
      //         height: 200,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(20),
      //           image: DecorationImage(
      //             image: AssetImage(itemsList[index]),
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //         child: Center(
      //           child: Text(
      //             itemsList[index],
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 24,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
