import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geo_x/data/static_variable.dart';

import '../module_common.dart';
import '../validator.dart';

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => new RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final controller_login = TextEditingController();
  final controller_full_login = TextEditingController();
  final controller_password = TextEditingController();

  //step = 0 - ввод ФИО и пароля, step = 1 ввод кода подтверждения/пароля
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("РЕГИСТРАЦИЯ"),
        ),
        body: new Container(
            padding: new EdgeInsets.all(20.0),
            child: new Form(
              child: new ListView(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.all(30.0),
                    child: new Image.asset(
                      "assets/images/logo.png",
                      height: 100.0,
                    ),
                  ),
                  new TextFormField(
                          controller: controller_full_login,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(labelText: 'ФИО'),
                        ),
                  new TextFormField(
                          controller: controller_login,
                          keyboardType: TextInputType.phone,
                          decoration: new InputDecoration(labelText: 'Телефон'),
                          inputFormatters: [
                            ValidatorInputFormatter(
                              editingValidator:
                                  DecimalPhoneEditingRegexValidator(),
                            )
                          ],
                        ),
                      new TextFormField(
                          controller: controller_password,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(labelText: 'Пароль'),
                        ),
                  new Container(
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: new ListTile(
                            title: new Text(
                              "Зарегистрироваться",
                              textAlign: TextAlign.center,
                            ),
                            onTap: this.registration,
                          ),
                          margin: new EdgeInsets.only(top: 20.0),
                        ),
                ],
              ),
            )));
  }


  void registration() async {
    if (controller_login.text.length != 0) {
      LoadingStart(context);
      try {
        var response = await http.post(
            Uri.parse('${ServerUrl}/registration/'),
            headers: {
              'content-type': 'application/json',
            },
            body:
                '{"username": "${controller_login.text}", "password": "${controller_password.text}", "full_name": "${controller_full_login.text}"}');
        if (response.statusCode == 200) {
          LoadingStop(context);
          Navigator.pop(context);
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
          new Text("Телефон не может быть пустым",
              style: new TextStyle(fontSize: 16.0)));
    }
  }
}
