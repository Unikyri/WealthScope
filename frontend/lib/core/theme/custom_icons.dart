import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Centralized access to App Icons using Phosphor Icons.
/// This allows for easy swapping of icon sets and consistent styling.
class CustomIcons {
  // Prevent instantiation
  CustomIcons._();

  // Navigation
  static const IconData home = PhosphorIconsRegular.house;
  static const IconData homeFilled = PhosphorIconsFill.house;
  static const IconData assets = PhosphorIconsRegular.coins;
  static const IconData assetsFilled = PhosphorIconsFill.coins;
  static const IconData analysis = PhosphorIconsRegular.chartLineUp;
  static const IconData analysisFilled = PhosphorIconsFill.chartLineUp;
  static const IconData ai = PhosphorIconsRegular.sparkle;
  static const IconData aiFilled = PhosphorIconsFill.sparkle;
  static const IconData settings = PhosphorIconsRegular.gearSix;
  static const IconData settingsFilled = PhosphorIconsFill.gearSix;

  // Actions
  static const IconData add = PhosphorIconsRegular.plus;
  static const IconData close = PhosphorIconsRegular.x;
  static const IconData arrowRight = PhosphorIconsRegular.arrowRight;
  static const IconData back = PhosphorIconsRegular.arrowLeft;
  static const IconData search = PhosphorIconsRegular.magnifyingGlass;
  static const IconData filter = PhosphorIconsRegular.faders;
  static const IconData sort = PhosphorIconsRegular.sortAscending;
  static const IconData edit = PhosphorIconsRegular.pencilSimple;
  static const IconData delete = PhosphorIconsRegular.trash;
  static const IconData share = PhosphorIconsRegular.shareNetwork;
  static const IconData info = PhosphorIconsRegular.info;
  
  // Finance specific
  static const IconData wallet = PhosphorIconsRegular.wallet;
  static const IconData trendingUp = PhosphorIconsRegular.trendUp;
  static const IconData trendingDown = PhosphorIconsRegular.trendDown;
  static const IconData dollar = PhosphorIconsRegular.currencyDollar;
  static const IconData pieChart = PhosphorIconsRegular.chartPie;
  static const IconData bank = PhosphorIconsRegular.bank;
  static const IconData creditCard = PhosphorIconsRegular.creditCard;

  // AI & Feedback
  static const IconData robot = PhosphorIconsRegular.robot;
  static const IconData microphone = PhosphorIconsRegular.microphone;
  static const IconData send = PhosphorIconsRegular.paperPlaneRight;
  static const IconData copy = PhosphorIconsRegular.copy;
  static const IconData refresh = PhosphorIconsRegular.arrowsClockwise;

  // Misc
  static const IconData notification = PhosphorIconsRegular.bell;
  static const IconData notificationFilled = PhosphorIconsFill.bell;
  static const IconData calendar = PhosphorIconsRegular.calendar;
  static const IconData user = PhosphorIconsRegular.user;
  static const IconData lock = PhosphorIconsRegular.lock;
  static const IconData eye = PhosphorIconsRegular.eye;
  static const IconData eyeSlash = PhosphorIconsRegular.eyeSlash;
}
