import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheProvider extends ChangeNotifier {
  SharedPreferences? prefs;

  CacheProvider() {
    initPreferences();
  }

  String? get city => prefs?.city;

  Future initPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future setCity(String location) async {
    await prefs?.setString('city', location);
    notifyListeners();
  }
}

extension on SharedPreferences {
  String? get city => getString('city');
}
