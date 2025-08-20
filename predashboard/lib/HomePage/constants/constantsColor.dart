import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {

static final Map<String, Color> primaryColors = {
  'askExpert': Color(0xFF9CCAFF),
  'internship': Color(0xFF8DDDB8),
  'status': Color(0xFFFFAAAA),
  'freshers': Color(0xFFFFBB8E),
  'hiremi360': Color(0xFFFFDB8E),
  'experience': Color(0xFFC4A6FF),
};
AppColors._();


static  Color primary = HexColor('#C1272D');


/// Other Colors
static Color green = HexColor('#34AD78');
static Color bgBlue = HexColor("#ECF5FF");
static Color lightGrey = HexColor('#F3F3F3');



/// background Colors
static Color lightOrange = HexColor('#FFF6E5');
static Color orange = HexColor('#E98740');
static Color lightOrange2 = HexColor('#FFEEE5');
static Color lightPink = HexColor('#FFE5EE');
static Color pink = HexColor('#ED509B');
/// Neutral Colors
static Color secondaryText = HexColor('#808080');
static const Color black = Colors.black;
static const Color white = Colors.white;
static const Color drawerIcon= Color(0xFF003DD1);
static List<Color> createGradient(Color darker, Color lighter) => [
      darker,
      Colors.white,
      lighter,
    ];

static final Map<String, List<Color>> gradients = {
  'askExpert': createGradient(primaryColors['askExpert']!, Color(0xFFCCE4FF)),
  'internship': createGradient(primaryColors['internship']!, Color(0xFFCCEEDE)),
  'status': createGradient(primaryColors['status']!, Color(0xFFFFD6D6)),
  'freshers': createGradient(primaryColors['freshers']!, Color(0xFFFFE1D1)),
  'hiremi360': createGradient(primaryColors['hiremi360']!, Color(0xFFFFEED1)),
  'experience': createGradient(primaryColors['experience']!, Color(0xFFE6D9FF)),
};


}
