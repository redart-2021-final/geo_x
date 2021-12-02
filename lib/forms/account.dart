import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_x/data/session_options.dart';
import 'package:geo_x/data/static_variable.dart';
import 'package:geo_x/module_common.dart';
import 'package:http/http.dart' as http;

//Класс инициализации
class AccountPage extends StatefulWidget {
  @override
  AccountPageState createState() => new AccountPageState();
}

class AccountPageState extends State<AccountPage> {

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(UserPhone);
    print(UserFullName);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("Добавление в группу"),
        ),
        body: new ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      new Card(
                        child: Column(
                          children: <Widget>[
                            new Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 0, top: 10, right: 15, left: 15),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.person),
                                      hintText: 'Введите значение',
                                      labelText: 'Имя пользователя *',
                                    ),
                                    controller: username,
                                  )
                                )),
                            new Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 10, top: 0, right: 15, left: 15),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.vpn_key_rounded),
                                      hintText: 'Введите значение',
                                      labelText: 'Пароь *',
                                    ),
                                    controller: password,
                                  ),
                                )),
                            new Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 10, top: 0, right: 15, left: 15),
                                  child: new Container(
                                    decoration:
                                    new BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: new ListTile(
                                      title: new Text(
                                        "Привязать",
                                        textAlign: TextAlign.center,
                                      ),
                                      onTap: () async{
                                        LoadingStart(context);
                                        try {

                                          var response = await http.post(
                                              Uri.parse('${ServerUrl}/users/children'),
                                              headers: {
                                                'Authorization': 'Basic ${AuthorizationString}',
                                                'content-type': 'application/json',
                                              },
                                              body: '{"username": "${username.text}", "password": "${password.text}"}');
                                          print('{"username": "${username.text}", "password": "${password.text}"}');
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
                                        };
                                      },
                                    ),
                                  ),
                                )),

                          ],
                        ),
                      ),
                    ])
        );
  }
}
