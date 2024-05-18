import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


bool isLoading = false;
wText(String text, { Color? color, double size = 16}) {
  return Text(
    text,
    style: GoogleFonts.roboto(
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