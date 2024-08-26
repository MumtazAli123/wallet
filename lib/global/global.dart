import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

SharedPreferences? sharedPreferences;

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentUser;
UserModel? userModelCurrentInfo;
String? dbRef;
String? uid;

// StreamSubscription<Position>? streamSubscriptionPosition;
// AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
// DriversData? onlineDriverData= DriversData();
String? fcmServerToken =
    "key=AAAAFI9Nj2A:APA91bHSqQoyzaSKkaxNeSGKRmWPlSU2qRO2Luu-o9xDD6mXgDEgOoRCeBRlX1VjwnEI3ErXgGn-za3x03CsBCVtL6QKJwWrsMmp515Q6FarHSs9EggCxmVhg9hvweMUmyoIsKuztK8A"; // for driversKey info list

String? userSearchHotelsAddress = "";
String? userCountryName = "";
// DirectionDetailsInfo? tripDirectionDetailsInfo; // for driversKey info list


Platform platform =
    (Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android) as Platform;

// locally database platform sharedPreferences, NSUserDefaults key ios and android platform name

String? userCurrentLocationAddress = "";

final hotelsImagesList = [
  "assets/images/popular_1.jpg",
  "assets/images/popular_2.jpg",
  "assets/images/popular_3.jpg",
  "assets/images/popular_4.jpg",
  "assets/images/popular_5.jpg",
  "assets/images/popular_6.jpg",
];

final List<String> hotelsNamesList = [
  "Hotel 0",
  "Hotel 1",
  "Hotel 2",
  "Hotel 3",
  "Hotel 4",
  "Hotel 5",
];

final itemsList = [
  "assets/slider/0.jpg",
  "assets/slider/1.jpg",
  "assets/slider/2.jpg",
  "assets/slider/3.jpg",
  "assets/slider/4.jpg",
  "assets/slider/5.jpg",
  "assets/slider/6.jpg",
  "assets/slider/7.jpg",
  "assets/slider/8.jpg",
  "assets/slider/9.jpg",
  "assets/slider/10.jpg",
  "assets/slider/11.jpg",
  "assets/slider/12.jpg",
  "assets/slider/13.jpg",

];

// CartMethods cartMethods = CartMethods();

double countStarsRating = 0.0;
String titleStarsRating = "";




