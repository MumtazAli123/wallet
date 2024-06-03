// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


bool isLoading = false;
wText(String text, { Color? color, double size = 16}) {
  return Text(
    textAlign: TextAlign.center,
    text,
    style: GoogleFonts.gabriela(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}
eText(String s, {required Color color}) {
  return Text(
    s,
    style: TextStyle(color: color),
  );
}

aText(String text, { Color? color, double size = 16}) {
  return Text(
    text,
    style: GoogleFonts.gabriela(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

cText(String text, { Color? color, double size = 16}) {
  return Text(
    text,
    style: GoogleFonts.paprika(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

wButton(String text, {Color? color, double size = 16, Function()? onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: isLoading
        ? const CircularProgressIndicator()
        : Container(
      alignment: Alignment.center,
           width: 250,
            height: 50,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: wText(
              text,
              color: Colors.white,
              size: 20,
            ),
          ),
  );
}

urlLauncher(String imgPath, String url, String title) {
  return Container(
    width: 80,
    height: 80,
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    ),
    child: GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          print('Could not launch $url');
        }
      },
      child: Column(
        children: [
          Image.asset(
            imgPath,
            width: 40,
            height: 40,
          ),
          wText(title, size: 10, color: Colors.black),
        ],
      ),
    ),
  );
}