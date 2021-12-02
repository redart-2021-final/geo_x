import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_x/forms/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:geo_x/module_common.dart';
import 'package:geo_x/data/static_variable.dart';
import 'package:geo_x/data/session_options.dart';
import 'package:geo_x/forms/registration.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool checkValue = false;

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getCredential();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white12,
      ),
      body: new SingleChildScrollView(
        child: _body(),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget _body() {
    return new Container(
      padding: EdgeInsets.only(right: 20.0, left: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.all(30.0),
            child: new Image.asset(
              "assets/images/logo.png",
              height: 100.0,
            ),
          ),
          new TextField(
            controller: username,
            decoration: InputDecoration(
                hintText: "Логин",
                hintStyle: new TextStyle(color: Colors.grey.withOpacity(0.3))),
          ),
          new TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Пароль",
                  hintStyle:
                      new TextStyle(color: Colors.grey.withOpacity(0.3)))),
          new CheckboxListTile(
            value: checkValue,
            onChanged: _onChanged,
            title: new Text("Запомнить"),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          new Container(
            decoration:
                new BoxDecoration(border: Border.all(color: Colors.black)),
            child: new ListTile(
              title: new Text(
                "Вход",
                textAlign: TextAlign.center,
              ),
              onTap: LoginOnClick,
            ),
          ),
          new Container(
            decoration:
                new BoxDecoration(border: Border.all(color: Colors.black)),
            child: new ListTile(
              title: new Text(
                "Регистрация",
                textAlign: TextAlign.center,
              ),
              onTap: RegistrationOnClick,
            ),
            margin: new EdgeInsets.only(top: 20.0),
          )
        ],
      ),
    );
  }

  _onChanged(bool? value) async {
    setState(() {
      checkValue = value!;
    });
  }

  setCredential(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("check", value);
    if (value) {
      sharedPreferences.setString("username", username.text);
      sharedPreferences.setString("password", password.text);
      //session variable
      sharedPreferences.setString("session_username", username.text);
      sharedPreferences.commit();
    } else {
      sharedPreferences.remove("username");
      sharedPreferences.remove("password");
    }
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("check")!;
      if (checkValue != null) {
        if (checkValue) {
          username.text = sharedPreferences.getString("username")!;
          password.text = sharedPreferences.getString("password")!;
        }
      } else {
        checkValue = false;
      }
    });
  }

  LoginOnClick() async {
    if (username.text.length != 0 || password.text.length != 0) {
      LoadingStart(context);
      try {
        var Authorization =
            base64.encode(utf8.encode(username.text + ':' + password.text));

        var response = await http.get(
            Uri.parse('${ServerUrl}/users/profile/'),
            headers: {
              'Authorization': 'Basic ${Authorization}'
            });
        if (response.statusCode == 200) {
          LoadingStop(context);
          print('auth complete');
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new HomePage()),
              (Route<dynamic> route) => false);
          setCredential(checkValue);
          //var json_response = json.decode(response.body);
          //UserFullName = json_response['full_name']!;
          //UserPhone = json_response['username']!;

          AuthorizationString = Authorization;
        } else {
          LoadingStop(context);
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.body}");
          CreateshowDialog(
              context,
              new Text(
                response.body,
                style: new TextStyle(fontSize: 16.0),
              ));
        }
      } catch (error) {
        LoadingStop(context);
        print(error.toString());
        CreateshowDialog(
            context,
            new Text(
              'Ошибка соединения с сервером',
              style: new TextStyle(fontSize: 16.0),
            ));
      }
      ;
    } else {
      CreateshowDialog(
          context,
          new Text("Логин или пароль \nне может быть пустым",
              style: new TextStyle(fontSize: 16.0)));
    }
  }

  RegistrationOnClick() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegistrationPage()));
  }
}

class _SliderIndicatorPainter extends CustomPainter {
  final double position;
  _SliderIndicatorPainter(this.position);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(position, size.height / 2), 12, Paint()..color = Colors.black);
  }
  @override
  bool shouldRepaint(_SliderIndicatorPainter old) {
    return true;
  }
}