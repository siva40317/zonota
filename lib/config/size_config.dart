
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
	static MediaQueryData _mediaQueryData;
	static double screenWidth;
	static double screenHeight;
	static double blockSizeHorizontal;
	static double blockSizeVertical;

	static double _safeAreaHorizontal;
	static double _safeAreaVertical;
	static double safeBlockHorizontal;
	static double safeBlockVertical;
	static var orientation;
	static bool isTab=false;
	static BuildContext acontext;
	static var h1,h2,h3,h4,h5,h6 ;
	static var t1,t2;
	static var b1,b2;
	static var s1,s2;
	static var isPortratit;
	void init(BuildContext context) {
		acontext=context;
		_mediaQueryData = MediaQuery.of(context);
		screenWidth = _mediaQueryData.size.width;
		screenHeight = _mediaQueryData.size.height;
		blockSizeHorizontal = screenWidth / 100;
		blockSizeVertical = screenHeight / 100;
		orientation = _mediaQueryData.orientation;
		_safeAreaVertical = _mediaQueryData.padding.top;


		h1 =  Theme.of(context).textTheme.headline1.fontSize;
		h2 = Theme.of(context).textTheme.headline2.fontSize;
		h3 = Theme.of(context).textTheme.headline3.fontSize;
		h4 = Theme.of(context).textTheme.headline4.fontSize;
		h5 = Theme.of(context).textTheme.headline5.fontSize;
		h6 = Theme.of(context).textTheme.headline6.fontSize;


		t1 = Theme.of(context).textTheme.subtitle1.fontSize;
		t2 = Theme.of(context).textTheme.subtitle2.fontSize;
		b1 = Theme.of(context).textTheme.bodyText1.fontSize;
		b2 = Theme.of(context).textTheme.bodyText2.fontSize;

		s1 = Theme.of(context).textTheme.caption.fontSize;
		s2 = Theme.of(context).textTheme.overline.fontSize;

		isPortratit = _mediaQueryData.orientation == Orientation.portrait;



	}

	static aspectRatio(ratio)
	{
		return (screenHeight) / 1000 * (ratio);
	}

	static dynamicheight(double fieldPercentage,safe) {
		double toolbar = _mediaQueryData.padding.top;
		return  safe?(screenHeight - toolbar) / 100 * (fieldPercentage):(screenHeight) / 100 * (fieldPercentage);
	}


	static dynamicwidth(double fieldPercentage,{safe=true}) {

		return screenWidth /100 * fieldPercentage;
	}

	static size(double sizePercentage,{safe=true})
	{
		return orientation==Orientation.portrait?dynamicheight(sizePercentage,safe):dynamicwidth(sizePercentage);
	}

	static height(double fieldPercentage,{safe=true})
	{
		return orientation==Orientation.portrait?dynamicheight(fieldPercentage,safe):dynamicwidth(kIsWeb?fieldPercentage/2:fieldPercentage);
	}

	static width(double fieldPercentage,{safe=true})
	{
		return orientation==Orientation.portrait?dynamicwidth(fieldPercentage):dynamicheight(kIsWeb?fieldPercentage/2:fieldPercentage,safe);
	}

	static fitheight(double fieldPercentage,{safe=true})
	{
		return dynamicheight(fieldPercentage,safe);
	}

	static fitwidth(double fieldPercentage,{safe=true})
	{
		return dynamicwidth(fieldPercentage);
	}


	static  fontSize() {

	}
}
