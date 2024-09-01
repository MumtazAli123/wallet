// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';


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
          child: CarouselView(
            scrollDirection: Axis.horizontal,
            shrinkExtent: 0.5,
            itemExtent: MediaQuery.of(context).size.height / 1.5,
            children: const [
              // Image.network(image1.toString(), fit: BoxFit.cover),
              // Image.network(image2.toString(), fit: BoxFit.cover),
              // Image.network(image3.toString(), fit: BoxFit.cover),
              // Image.network(image4.toString(), fit: BoxFit.cover),
              // Image.network(image5.toString(), fit: BoxFit.cover),
            ],
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
