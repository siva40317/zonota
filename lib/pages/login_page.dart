import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/common/image_asset.dart';
import 'package:zonota/config/size_config.dart';
import 'package:zonota/repositories/repository.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'splash_screen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String name="";
  String phone="";
  String otp="";
  var loading = false;
  FirebaseAuth auth;
  bool hasError = false;
  var otpMode = false;
  var verificationId ="";

  TextEditingController controller = TextEditingController();
  int pinLength = 6;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = FirebaseAuth.instance;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(child:Container(
      child:SingleChildScrollView(child:new Column(
        children: <Widget>[
          SizedBox(height:SizeConfig.fitheight(10),),
          getLogo(),
          getAppText(),
          SizedBox(height:SizeConfig.fitheight(5),),

          SizedBox(height:SizeConfig.fitheight(5),),
          Container(
            alignment:Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: SizeConfig.width(5), right: SizeConfig.width(5)),
            child: new Text(
              otpMode?"Enter OTP":"Phone",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.colorFromHex(AppColors.primary),
                fontSize: 15.0,
              ),
            ),
          ),

          
          SizedBox(height:SizeConfig.fitheight(2),),

          otpMode?getOTPTextField():getPhoneTextField(),
          SizedBox(height:SizeConfig.fitheight(5),),

          getSignUpButton(),
          SizedBox(height:SizeConfig.fitheight(5),),





        ],
      ),
      ))));
  }

  getLogo()
  {
    return   Container(

      child: Center(
          child:Image.asset(ImageAsset.logo,height:SizeConfig.fitheight(20),)
      ),
    );
  }
  getAppText()
  {
    return   Container(

      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Zo",
            style: TextStyle(
                color:AppColors.colorFromHex(AppColors.primary),
                fontSize: SizeConfig.h3,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "NoTa",
            style: TextStyle(
                color:AppColors.colorFromHex(AppColors.primary),
                fontSize: SizeConfig.h3
            ),
          ),

        ],
      ),
    );
  }
 /* getNameTextField() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.width(5), right: SizeConfig.width(5)),
              child: new Text(
                "Name",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorFromHex(AppColors.primary),
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(height:SizeConfig.height(1),),
            Container(

                height:SizeConfig.fitheight(7),

                decoration: BoxDecoration(
                  color:AppColors.colorFromHex(AppColors.whiteSmoke),
                  border: Border(
                    bottom: BorderSide(
                        color: AppColors.colorFromHex(AppColors.primary),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                margin: EdgeInsets.only(left:SizeConfig.width(5),right:SizeConfig.width(5)),
                child: TextField(
                  onChanged:(value)
                  {
                    setState(() {
                      name=value;
                    });
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Name',
                    contentPadding:EdgeInsets.all(SizeConfig.width(2)),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ))
          ],
        ));

  }*/

  getPhoneTextField() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Container(

                height:SizeConfig.fitheight(8),

                decoration: BoxDecoration(
                  color:AppColors.colorFromHex(AppColors.whiteSmoke),
                  border: Border(
                    bottom: BorderSide(
                        color: AppColors.colorFromHex(AppColors.primary),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                margin: EdgeInsets.only(left:SizeConfig.width(5),right:SizeConfig.width(5)),
                child: TextField(
                  keyboardType:TextInputType.numberWithOptions(signed:false,decimal:false),
                  onChanged:(value)
                  {
                    setState(() {
                      phone=value;
                    });
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Phone',
                    contentPadding:EdgeInsets.all(SizeConfig.width(2)),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ))
          ],
        ));

  }

  getSignUpButton()
  {
    return Container(
        width:SizeConfig.width(90),
        height:SizeConfig.height(8),

        child:ElevatedButton(
          style:ElevatedButton.styleFrom(
              elevation:SizeConfig.size(2),
              primary:AppColors.colorFromHex(AppColors.primary)
          ),
          onPressed:!loading&&phone.length>9?()async
          {

            otpMode?verifyOTP(verificationId, otp):handleOtp();

          }:null,
          child: loading ?Container(child:CircularProgressIndicator(),):Text(otpMode?"VERIFY OTP":"SEND OTP",style:TextStyle(color:Colors.white),),
        ));
  }

  getSignInButton()
  {
    return Container(
      child:TextButton(
        onPressed:()
        {

        },
        child:Text("Already Have Account? SIGN IN",style:TextStyle(color:AppColors.colorFromHex(AppColors.primary)),),
      ),
    );
  }


  getOTPTextField() {
    return PinCodeTextField(
      autofocus: false,
      controller: controller,
      highlight: true,
      pinBoxHeight: 50,
      pinBoxWidth: 50,
      highlightColor: AppColors.colorFromHex(AppColors.primary),
      defaultBorderColor: AppColors.colorFromHex(AppColors.grey900),
      hasTextBorderColor: AppColors.colorFromHex(AppColors.grey900),
      maxLength: pinLength,
      onTextChanged: (text) {
        otp = text;
        setState(() {

        });
      },
      onDone: (text) {
        otp = text;
        setState(() {

        });
        verifyOTP(verificationId, otp);
      },
      wrapAlignment: WrapAlignment.spaceAround,
      pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
      pinTextStyle: TextStyle(fontSize: 30.0),
      pinTextAnimatedSwitcherTransition:
      ProvidedPinBoxTextAnimation.scalingTransition,
//                    pinBoxColor: Colors.green[100],
      pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
//                    highlightAnimation: true,

      keyboardType: TextInputType.number,
    );
  }


  verifyOTP(String verificationId, String otp)
  {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    verifyCredential(phoneAuthCredential);
  }


  Future<bool> verifyCredential(phoneAuthCredential) async {
    setState(() {
      loading = true;
    });
   var done =  await auth.signInWithCredential(phoneAuthCredential).catchError((e) {
      setState(() {
        loading = false;
      });
    });


    if(done!=null)
      {
        var user =  await RepositoryImpl().fetchUserData();
        if (user!=null) {
          await Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => SplashScreen(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            ),
          );
        }
        else
        {
          var done  = await RepositoryImpl().registerUser(phone,name);
          if(done)
          {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => SplashScreen(),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 300),
              ),
            );
          }
          else
          {
            Fluttertoast.showToast(msg: "Error setting up");
            setState(() {
              loading=false;
            });
          }
        }
      }
    else
      {
        Fluttertoast.showToast(msg: "Invalid OTP");
      }


  }


  Future<void> handleOtp() async {
    setState(() {
      loading =true;
    });
    await auth.verifyPhoneNumber(
      timeout: Duration(seconds: 60),
      phoneNumber: '+91' + phone,
      verificationCompleted: (credential) async {
        controller.text=credential.smsCode;
        verifyCredential(credential);


        },
      verificationFailed: (e) {
        setState(() {
          loading= false;
        });
        Fluttertoast.showToast(msg: e.message);
      },
      codeSent: (String a, b) {
        setState(() {
          verificationId = a;
          otpMode = true;
          loading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}