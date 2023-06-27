import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

var kTextFieldDecoration = InputDecoration(
    hintText: 'Enter your email',
    hintStyle: TextStyle(
      color: Colors.grey[400],
      fontSize: 16,
    ),
    contentPadding:
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: InputBorder.none);

const kTextInputStyle = TextStyle(
  color: Colors.black,
);

Widget text2(context, text, onTap, id) {
  return TextButton(
    child: const Text(
      'New User? Sign Up',
    ),
    onPressed: () {
      Navigator.pushNamed(context, id);
    },
  );
}

class AppColors {
  static Color onBoarding1 = const Color(0xffBAD3C8);
  static Color onBoarding2 = const Color(0xffFFE59E);
  static Color onBoarding3 = const Color(0xffDC9696);
}
