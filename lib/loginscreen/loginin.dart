// ignore_for_file: prefer_const_constructors, deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_tracker/screens/homepage2.dart';

enum MobileVerificationState {
  // ignore: constant_identifier_names
  SHOW_MOBILE_FROM_STATE,
  // ignore: constant_identifier_names
  SHOW_OTP_FROM_STATE,
}

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  MobileVerificationState currentsState =
      MobileVerificationState.SHOW_MOBILE_FROM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user = FirebaseAuth.instance.currentUser;
  late String verificationId;
  bool showLoading = false;

  void signInwithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      _saffoldKey.currentState
          ?.showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  getMobileFromWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: phoneController,
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            icon: Icon(
              Icons.phone_android_outlined,
              color: Colors.white,
            ),
            hintText: 'Enter Phone Number',
            hintStyle: TextStyle(fontSize: 20, color: Colors.white),
            prefix: Padding(
              padding: EdgeInsets.all(4),
              child: Text('+91'),
            ),
          ),
          maxLength: 10,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
            });
            await _auth.verifyPhoneNumber(
              phoneNumber: '+91${phoneController.text}',
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
                _saffoldKey.currentState?.showSnackBar(
                    SnackBar(content: Text(verificationFailed.message!)));
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentsState = MobileVerificationState.SHOW_OTP_FROM_STATE;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
          },
          child: Text(
            'SENT',
          ),
          color: Colors.green.shade400,
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }

  getOtpFromWIdget(context) {
    return SafeArea(
      child: Column(
        children: [
          Spacer(),
          TextField(
            controller: otpController,
            style: TextStyle(fontSize: 20, color: Colors.white),
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock_outline_rounded,
                color: Colors.white,
              ),
              hintText: 'ENTER OTP',
              hintStyle: TextStyle(fontSize: 20, color: Colors.white),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 16,
          ),
          FlatButton(
            onPressed: () async {
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otpController.text);

              signInwithPhoneAuthCredential(
                  phoneAuthCredential); // use the phoneAuthCredential to signin into the application
            },
            child: Text('VERIFY'),
            color: Colors.green.shade400,
            textColor: Colors.white,
          ),
          Spacer(),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _saffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _saffoldKey,
      body: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(color: Color.fromRGBO(7, 84, 84, 1.9)),
        child: showLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : currentsState == MobileVerificationState.SHOW_MOBILE_FROM_STATE
                ? getMobileFromWidget(context)
                : getOtpFromWIdget(context),
        padding: EdgeInsets.all(16),
      ),
    );
  }
}
