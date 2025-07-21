import 'package:flutter/material.dart';

class SizeConfig {
  static late  MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  //Padding
  static double paddingSmall = 10;
  static double paddingLarge = 20;
  static double paddingXLarge = 30;
  static double tenPercentWidth = 10;
  static double thirtyFourPercentHeight = 34;
  static double fiftyThreePercentHeight = 53;
  static double seventyPercentHeight = 70;
  static double eighteenPercentHeight = 18;
  static double thirtySixPercentHeight = 36;
  // static double thirtyPercentHeight = 36;
  static double thirtySevenPercentHeight = 37;
  static double thirtyEightPercentHeight = 38;
  static double seventyEightPercentHeight = 78;
  static double eightySixPercentHeight = 86;
  static double ninetyThreePercentHeight = 93;
  static double sixtyPercentHeight = 60;
  static double eightyFivePercentWidth = 85;
  static double eightyPercentWidth = 80;
  static double seventyPercentWidth = 70;
  static double seventyFivePercentWidth = 75;
  static double thirtyPercentWidth = 30;
  static double sixtyPercentWidth = 60;
  static double twentyPercentWidth = 20;
  static double fortyPercentHeight = 40;
  static double sixtyFivePercentWidth = 65;
  static double fiftyPercentWidth = 50;
  static double twentyEightPercentHeight = 28;
  static double eightPercentWidth = .8;

  //margin
  static double marginVerticalXXsmall = 7.5;
  static double marginVerticalXsmall = 8;
  static double marginVerticalSmall = 10;
  static double marginVerticalStander = 14;
  static double marginVerticalLarge = 20;
  static double marginVerticalXLarge = 30;
  static double marginVerticalXXLarge = 60;
  static double marginVerticalXXXLarge = 90;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth/ 100;
    blockSizeVertical = screenHeight / 100;

    //Padding
    tenPercentWidth = blockSizeHorizontal*10;
    thirtyFourPercentHeight = blockSizeVertical*34;
    fiftyThreePercentHeight = blockSizeVertical*53;
    fortyPercentHeight = blockSizeVertical*40;
    thirtySevenPercentHeight = blockSizeVertical*37;
    thirtyEightPercentHeight = blockSizeVertical*38;
    seventyPercentHeight = blockSizeVertical*70;
    seventyEightPercentHeight = blockSizeVertical*78;
    eightySixPercentHeight = blockSizeVertical*86;
    ninetyThreePercentHeight = blockSizeVertical*93;
    twentyEightPercentHeight = blockSizeVertical*28;
    eighteenPercentHeight = blockSizeVertical*18;
    sixtyPercentHeight = blockSizeVertical*60;
    thirtySixPercentHeight = blockSizeVertical*36;
    eightyPercentWidth = blockSizeHorizontal*80;
    sixtyPercentWidth = blockSizeHorizontal*60;
    eightPercentWidth = blockSizeHorizontal*8;
    eightyFivePercentWidth = blockSizeHorizontal*85;
    sixtyFivePercentWidth = blockSizeHorizontal*65;
    fiftyPercentWidth = blockSizeHorizontal*50;
    seventyFivePercentWidth = blockSizeHorizontal*75;
    seventyPercentWidth = blockSizeHorizontal*70;
    thirtyPercentWidth = blockSizeHorizontal*30;
    twentyPercentWidth = blockSizeHorizontal*20;
    paddingSmall = blockSizeHorizontal * 2.5;
    paddingLarge = blockSizeHorizontal * 8;
    paddingXLarge=blockSizeHorizontal * 10;


    //margin
    marginVerticalXXsmall = blockSizeHorizontal;
    marginVerticalXsmall = blockSizeHorizontal * 1.5;
    marginVerticalSmall = blockSizeHorizontal * 2.4;
    marginVerticalStander = blockSizeHorizontal * 3;
    marginVerticalLarge = blockSizeHorizontal * 4;
    marginVerticalXLarge = blockSizeHorizontal * 7;
    marginVerticalXXLarge = blockSizeHorizontal * 10;
    marginVerticalXXXLarge = blockSizeHorizontal * 15;
  }
}

Widget horizontalSpace(double width) => SizedBox(width: width);

Widget verticalSpace(double height) => SizedBox(height: height);