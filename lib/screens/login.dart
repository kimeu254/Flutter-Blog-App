import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/api_response.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'home.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) =>
                    val!.isEmpty ? 'Invalid email address' : null,
                decoration: kInputDecoration('Email')),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: txtPassword,
                obscureText: true,
                validator: (val) => val!.isEmpty ? 'Required min 6 char' : null,
                decoration: kInputDecoration('Password')),
            SizedBox(
              height: 10,
            ),
            TextButton(
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.blue),
                  padding: MaterialStateProperty.resolveWith(
                      (states) => EdgeInsets.symmetric(vertical: 10))),
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  _loginUser();
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            kLoginRegisterHint('Dont have an account?', 'Register', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Register()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
