// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import '../global/global.dart';

class SliderPics extends StatelessWidget {
  const SliderPics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: itemsList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(itemsList[index]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  itemsList[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
