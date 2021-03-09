// import 'package:firebase_otp/home_screen.dart';
// import 'package:firebase_otp/login_service.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class OtpVerify extends StatefulWidget {
  final String verificationId;

  const OtpVerify({Key key, this.verificationId}) : super(key: key);
  @override
  _OtpVerifyState createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String code;
  bool hasError = false;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff6fc560),
        title: Text('OTP Verify'),
      ),
      body: Builder(
        builder: (ctx) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 300,
                child: Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 20,
              ),

              // PinEntryTextField(
              //   showFieldAsBox: true,
              //   fields: 6,
              //   onSubmit: (value) => code = value,
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  // obscureText: true,
                  // obscuringCharacter: '*',
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v.length < 5) {
                      return "Not here yet";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    inactiveFillColor: Color(0xffF4F5F7),
                    activeColor: Color(0xfffdc100),
                    inactiveColor: Colors.black.withOpacity(0.14),
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 70,
                    fieldWidth: 48,
                    selectedFillColor: Colors.white,
                    activeFillColor: hasError ? Colors.orange : Colors.white,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.white,
                  enableActiveFill: true,

                  errorAnimationController: errorController,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  onCompleted: (v) {
                    print("Completed");
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      code = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                width: 300,
                child: Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    // LoginService().signInWithPhoneNumber(code, widget.verificationId).then((value){
                    //   if(value == false){
                    //     Scaffold.of(ctx).showSnackBar(SnackBar(
                    //       content: const Text('OTP failed'),
                    //       duration: const Duration(seconds: 1),
                    //     ));
                    //   }else{
                    //     print('true');
                    //     Phoenix.rebirth(context);
                    //   }
                    // });
                  },
                  child: Container(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xff6fc560),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
