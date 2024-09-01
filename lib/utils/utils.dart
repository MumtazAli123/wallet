// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

pickImage(ImageSource source) async {
  // pick image from gallery
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: source);
  if (image != null) {
    return await image.readAsBytes();
  }
  print('No image selected.');
}

class ImageShowCase extends StatelessWidget {
  final List <String> imageUrl;
  const ImageShowCase({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final imageWidget = <Widget>[];
    for (var i = 0; i < imageUrl.length; i++) {
      SingleImageShowCase(imageUrl: imageUrl[i]);
    }
    if (imageWidget.isEmpty) {
      return Container();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: imageWidget,
      ),
    );
  }
}

class SingleImageShowCase extends StatelessWidget {
  final String imageUrl;
  const SingleImageShowCase({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.all(8),
      child: Image.network(
        imageUrl,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}


bool isLoading = false;

//shared widgets
class UtilsApp{
  static Widget wText(String text, {Color? color, double size = 16}) {
    return Text(
      text,
      style: GoogleFonts.gabriela(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Widget aText(String text, {Color? color, double size = 16}) {
    return Text(
      text,
      style: GoogleFonts.gabriela(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Widget cText(String text, {Color? color, double size = 16}) {
    return Text(
      text,
      style: GoogleFonts.paprika(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Widget wButton(String text, {Color? color, double size = 16, Function()? onPressed}) {
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

//   share dialog
  static void share(BuildContext context, String text) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share(text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}