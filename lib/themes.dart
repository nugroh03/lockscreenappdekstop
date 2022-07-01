import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const double defaultMargin = 20.0;

// Note: Heigh and width

Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  return displaySize(context).width;
}

// Note: Colors
Color primary = Color(0xff732B80);
Color secondary = Color(0xffFAE55D);
Color third = Color(0xffA6B5F4);
Color fourth = Color(0xffA8A6AD);
Color fifth = Color(0xff791200);

Color whiteColor = Color(0xffffffff);

FontWeight light = FontWeight.w300;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w700;
FontWeight bold = FontWeight.bold;

TextStyle gotham = TextStyle(fontFamily: "Gotham");
//TextStyle gothamLight = TextStyle(fontFamily: "GothamLight");
//TextStyle lato = GoogleFonts.lato();