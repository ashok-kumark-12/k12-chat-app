import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/round_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/services/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class RegistrationScreen extends StatelessWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: RegsiterForm());
  }
}

class RegsiterForm extends StatefulWidget {
  const RegsiterForm({super.key});

  @override
  State<RegsiterForm> createState() => _RegsiterFormState();
}

class _RegsiterFormState extends State<RegsiterForm> {
  final _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool _saving = false;

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _controller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
    if (text.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(text)) {
      return "Enter valid email address";
    }
    // return null if the text is valid
    return null;
  }

  bool _submitted = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, TextEditingValue value, __) {
        return ModalProgressHUD(
          inAsyncCall: _saving,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() {
                    email = value;
                  }),
                  style: kTextInputStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    errorText: _submitted ? _errorText : null,
                  ),
                  controller: _controller,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {
                    //Do something with the user input.
                    password = value;
                  },
                  style: kTextInputStyle,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Choose a Password'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  buttonColor: (password == null)
                      ? Colors.grey[400]!
                      : Colors.blueAccent,
                  textOnButton: 'Register',
                  callBack: () async {
                    setState(() {
                      _submitted = true;
                    });
                    if (_errorText == null) {
                      // print(email);
                      setState(() {
                        _saving = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email!, password: password!);

                        Navigator.pushNamed(context, ChatScreen.id);
                        setState(() {
                          _saving = false;
                        });
                        Fluttertoast.showToast(
                          msg: 'Welcome to Flash Chat',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.white,
                          textColor: Colors.black87,
                          fontSize: 16.0,
                        );
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          _saving = false;
                        });
                        String errorMessage;
                        errorMessage = getErrorMessage('signup', e.code);

                        debugPrint(e.code);
                        Fluttertoast.showToast(
                            msg: errorMessage,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.red[400],
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    } else {
                      null;
                    }
                  },
                ),
                TextButton(
                  child: const Text(
                    'Already a user',
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
